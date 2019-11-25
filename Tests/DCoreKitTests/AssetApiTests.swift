import XCTest
import RxBlocking
import BigInt

@testable import DCoreKit

final class AssetApiTests: XCTestCase {

    private let rest = DCore.Sdk.create(forRest: DCore.TestConstant.httpUrl)
    private let wss = DCore.Sdk.create(forWss: DCore.TestConstant.wsUrl)
    private let creds = try? Credentials(
        "1.2.27".asObjectId(), wif: "5Hxwqx6JJUBYWjQNt8DomTNJ6r6YK8wDJym4CMAH1zGctFyQtzt"
    )
    
    func testGetAssetById() {
        let asset = try? rest.asset.get(byId: "1.3.0").debug().toBlocking().single()
        XCTAssertEqual(asset?.id, DCore.Constant.dct)
    }
    
    func testGetAssetBySymbol() {
        let asset = try? rest.asset.get(bySymbol: .dct).debug().toBlocking().single()
        XCTAssertEqual(asset?.id, DCore.Constant.dct)
    }

    private func createAsset(credentials: Credentials, symbol: String) -> Asset {
        let create = try? wss.asset.create(
            credentials: credentials, symbol: symbol, precision: 6, description: symbol
        ).debug().toBlocking().single()
        XCTAssertNotNil(create)

        return (try? rest.asset.get(bySymbol: Asset.Symbol.from(symbol)).debug().toBlocking().single())!
    }
    
    func testCreateAssetAndGetBySymbols() {
        _ = createAsset(credentials: creds!, symbol: Asset.Symbol.alx.description)

        let assets = try? rest.asset.getAll(bySymbols: [.alx, .dct]).debug().toBlocking().single()
        XCTAssertEqual(assets?.count, 2)
    }

    func testCreateAssetAndIssueAsset() {
        let asset = createAsset(credentials: creds!, symbol: "ISSUE")

        let issue = try? wss.broadcast.broadcastWithCallback(AssetIssueOperation(
            issuer: creds!.accountId,
            assetToIssue: AssetAmount(with: 6000000, assetId: asset.id.description),
            issueToAccount: creds!.accountId,
            memo: Memo("message")
        ), keypair: creds!.keyPair).debug().toBlocking().single()
        XCTAssertNotNil(issue)
    }

    func testCreateAssetAndFundPool() {
        let asset = createAsset(credentials: creds!, symbol: "FUNDPOOL")

        let fundPools = try? wss.broadcast.broadcastWithCallback(AssetFundPoolsOperation(
            fromAccount: creds!.accountId,
            uiaAsset: AssetAmount(0, assetId: asset.id),
            dctAsset: AssetAmount(with: 100000)
        ), keypair: creds!.keyPair).debug().toBlocking().single()
        XCTAssertNotNil(fundPools)
    }

    func testAssetReserveOperation() {
        let assetReserve = try? wss.broadcast.broadcastWithCallback(AssetReserveOperation(
            payer: creds!.accountId, amountToReserve: AssetAmount(1)
        ), keypair: creds!.keyPair).debug().toBlocking().single()
        XCTAssertNotNil(assetReserve)
    }

    func testAssetClaimFeesOperation() {
        let asset = createAsset(credentials: creds!, symbol: "CLAIMFEES")
        _ = try? wss.broadcast.broadcastWithCallback(AssetIssueOperation(
            issuer: creds!.accountId,
            assetToIssue: AssetAmount(99999999999, assetId: asset.id),
            issueToAccount: creds!.accountId,
            memo: Memo("message")
        ), keypair: creds!.keyPair).debug().toBlocking().single()

        _ = try? wss.broadcast.broadcastWithCallback(AssetFundPoolsOperation(
            fromAccount: creds!.accountId,
            uiaAsset: AssetAmount(9999999999, assetId: asset.id),
            dctAsset: AssetAmount(with: 9999999999)
        ), keypair: creds!.keyPair).debug().toBlocking().single()

        _ = try? wss.account.transfer(
            from: creds!, to: "1.2.28", amount: AssetAmount(1), fee: AssetAmount(100000, assetId: asset.id)
        ).debug().toBlocking().single()

        let assetClaimFees = try? wss.broadcast.broadcastWithCallback(AssetClaimFeesOperation(
            issuer: creds!.accountId, uiaAsset: AssetAmount(1, assetId: asset.id), dctAsset: AssetAmount(1)
        ), keypair: creds!.keyPair).debug().toBlocking().single()
        XCTAssertNotNil(assetClaimFees)
    }

    func testAssetUpdateAdvancedOperation() {
        let asset = createAsset(credentials: creds!, symbol: "UPDATEADVANCED")

        let updateAdvanced = try? wss.broadcast.broadcastWithCallback(AssetUpdateAdvancedOperation(
            issuer: creds!.accountId, assetToUpdate: asset.id, precision: 6, fixedMaxSupply: true
        ), keypair: creds!.keyPair).debug().toBlocking().single()
        XCTAssertNotNil(updateAdvanced)
    }

    func testFormatAssetAmountToDecimal() {
        let asset = try? rest.asset.get(bySymbol: .dct).debug().toBlocking().single()
        let decimal = asset?.from(raw: 100000000)
        
        XCTAssertEqual(decimal, 1)
    }

    func testFormatAssetAmountFromDecimal() {
        let asset = try? rest.asset.get(bySymbol: .dct).debug().toBlocking().single()
        let raw = ((try? asset?.to(raw: 1)) as BigInt??)
        
        XCTAssertEqual(raw, 100000000)
    }

    func testFormatAssetAmountFromDecimalWhenSmallerThanPrecision() {
        let asset = try? rest.asset.get(bySymbol: .dct).debug().toBlocking().single()
        XCTAssertThrowsError(try asset?.to(raw: 0.00000000001))
    }
    
    func testFormatAssetAmountFromString() {
        let asset = try? rest.asset.get(bySymbol: .dct).debug().toBlocking().single()
        let raw = ((try? asset?.amount("1")) as AssetAmount??)
        
        XCTAssertEqual(raw, AssetAmount(100000000))
    }
    
    func testFormatAssetAmountFromDouble() {
        let asset = try? rest.asset.get(bySymbol: .dct).debug().toBlocking().single()
        let raw = ((try? asset?.amount(Double(1))) as AssetAmount??)
        
        XCTAssertEqual(raw, AssetAmount(100000000))
    }
    
    func testFormatAssetAmountFormattedString() {
        let asset = try? rest.asset.get(bySymbol: .dct).debug().toBlocking().single()
        let formatted = asset?.format(100000000)

        XCTAssertEqual(formatted, "1 DCT")
    }
    
    func testFormatAssetAmountFormattedStringFromNegative() {
        let asset = try? rest.asset.get(bySymbol: .dct).debug().toBlocking().single()
        let formatted = asset?.format(-100000000)
        
        XCTAssertEqual(formatted, "-1 DCT")
    }
    
    func testGetAssetsByBoundary() {
        let assets = try? rest.asset.findAllRelative(byLower: "", limit: 100).debug().toBlocking().single()
        XCTAssertNotNil(assets)
    }
    
    func testGetAssetsByBoundaryAndWrongLimit() {
        XCTAssertThrowsError(try rest.asset.findAllRelative(byLower: "a", limit: 1000).debug().toBlocking().single())
    }
    
    func testObjectIdHashing() {
        let create = try? wss.asset.create(
            credentials: creds!, symbol: Asset.Symbol.aia.description, precision: 6, description: "ALX"
        ).debug().toBlocking().single()
        XCTAssertNotNil(create)

        let assets = try? rest.asset.getAll(bySymbols: [.aia, .dct]).debug().toBlocking().single()
        XCTAssertNotNil(assets)
        let a = [assets!, assets!].joined()
        
        XCTAssertTrue(Set(a).count == 2)
    }
    
    static var allTests = [
        ("testGetAssetById", testGetAssetById),
        ("testGetAssetBySymbol", testGetAssetBySymbol),
        ("testCreateAssetAndGetBySymbols", testCreateAssetAndGetBySymbols),
        ("testCreateAssetAndIssueAsset", testCreateAssetAndIssueAsset),
        ("testCreateAssetAndFundPool", testCreateAssetAndFundPool),
        ("testAssetReserveOperation", testAssetReserveOperation),
        ("testAssetClaimFeesOperation", testAssetClaimFeesOperation),
        ("testAssetUpdateAdvancedOperation", testAssetUpdateAdvancedOperation),
        ("testFormatAssetAmountToDecimal", testFormatAssetAmountToDecimal),
        ("testFormatAssetAmountFromDecimal", testFormatAssetAmountFromDecimal),
        ("testFormatAssetAmountFromString", testFormatAssetAmountFromString),
        ("testFormatAssetAmountFromDouble", testFormatAssetAmountFromDouble),
        ("testFormatAssetAmountFormattedString", testFormatAssetAmountFormattedString),
        ("testFormatAssetAmountFormattedStringFromNegative", testFormatAssetAmountFormattedStringFromNegative),     
        ("testGetAssetsByBoundaryAndWrongLimit", testGetAssetsByBoundaryAndWrongLimit),
        ("testGetAssetsByBoundary", testGetAssetsByBoundary),
        ("testObjectIdHashing", testObjectIdHashing),
    ]

}
