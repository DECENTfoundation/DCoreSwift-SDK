import XCTest
import RxBlocking


@testable import DCoreKit

final class AssetApiTests: XCTestCase {

    private let rest = DCore.Sdk.create(forRest: "https://stagesocket.decentgo.com:8090/rpc")
    
    func testGetAssetById() {
        let asset = try? rest.asset.getAsset(byId: "1.3.0".dcore.chainObject!).debug().toBlocking().single()
        XCTAssertEqual(asset?.id, DCore.Constant.dct)
    }
    
    func testGetAssetBySymbol() {
        let asset = try? rest.asset.getAsset(bySymbol: .dct).debug().toBlocking().single()
        XCTAssertEqual(asset?.id, DCore.Constant.dct)
    }
    
    func testGetAssetsBySymbols() {
        let assets = try? rest.asset.getAssets(bySymbols: [.alat, .alxt, .dct]).debug().toBlocking().single()
        XCTAssertEqual(assets?.count, 3)
    }

    func testFormatAssetAmountToDecimal() {
        let asset = try? rest.asset.getAsset(bySymbol: .dct).debug().toBlocking().single()
        let decimal = asset?.from(raw: 100000000)
        
        XCTAssertEqual(decimal, 1)
    }

    func testFormatAssetAmountFromDecimal() {
        let asset = try? rest.asset.getAsset(bySymbol: .dct).debug().toBlocking().single()
        let raw = asset?.to(raw: 1)
        
        XCTAssertEqual(raw, 100000000)
    }
    
    func testFormatAssetAmountFromString() {
        let asset = try? rest.asset.getAsset(bySymbol: .dct).debug().toBlocking().single()
        let raw = asset?.amount("1")
        
        XCTAssertEqual(raw, AssetAmount(100000000))
    }
    
    func testFormatAssetAmountFromDouble() {
        let asset = try? rest.asset.getAsset(bySymbol: .dct).debug().toBlocking().single()
        let raw = asset?.amount(Double(1))
        
        XCTAssertEqual(raw, AssetAmount(100000000))
    }
    
    func testFormatAssetAmountFormattedString() {
        let asset = try? rest.asset.getAsset(bySymbol: .dct).debug().toBlocking().single()
        let formatted = asset?.format(100000000)

        XCTAssertEqual(formatted, "1 DCT")
    }
    
    func testFormatAssetAmountFormattedStringFromNegative() {
        let asset = try? rest.asset.getAsset(bySymbol: .dct).debug().toBlocking().single()
        let formatted = asset?.format(-100000000)
        
        XCTAssertEqual(formatted, "-1 DCT")
    }
    
    func testGetAssetsByBoundaryAndWrongLimit() {
        XCTAssertThrowsError(try rest.asset.getAssets(byLowerBound: "a", limit: 1000).debug().toBlocking().single())
    }
    
    static var allTests = [
        ("testGetAssetById", testGetAssetById),
        ("testGetAssetBySymbol", testGetAssetBySymbol),
        ("testGetAssetsBySymbols", testGetAssetsBySymbols),
        ("testFormatAssetAmountToDecimal", testFormatAssetAmountToDecimal),
        ("testFormatAssetAmountFromDecimal", testFormatAssetAmountFromDecimal),
        ("testFormatAssetAmountFromString", testFormatAssetAmountFromString),
        ("testFormatAssetAmountFromDouble", testFormatAssetAmountFromDouble),
        ("testFormatAssetAmountFormattedString", testFormatAssetAmountFormattedString),
        ("testFormatAssetAmountFormattedStringFromNegative", testFormatAssetAmountFormattedStringFromNegative),     
        ("testGetAssetsByBoundaryAndWrongLimit", testGetAssetsByBoundaryAndWrongLimit),
    ]

}
