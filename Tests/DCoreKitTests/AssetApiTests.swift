import XCTest
import RxBlocking


@testable import DCoreKit

final class AssetApiTests: XCTestCase {

    private let rest = DCore.Sdk.create(forRest: "https://api.decent.ch/rpc")
    
    func testGetAssetById() {
        let asset = try? rest.asset.get(byId: "1.3.0").debug().toBlocking().single()
        XCTAssertEqual(asset?.id, DCore.Constant.dct)
    }
    
    func testGetAssetBySymbol() {
        let asset = try? rest.asset.get(bySymbol: .dct).debug().toBlocking().single()
        XCTAssertEqual(asset?.id, DCore.Constant.dct)
    }
    
    func testGetAssetsBySymbols() {
        let assets = try? rest.asset.getAll(bySymbols: [.aia, .alx, .dct]).debug().toBlocking().single()
        XCTAssertEqual(assets?.count, 3)
    }

    func testFormatAssetAmountToDecimal() {
        let asset = try? rest.asset.get(bySymbol: .dct).debug().toBlocking().single()
        let decimal = asset?.from(raw: 100000000)
        
        XCTAssertEqual(decimal, 1)
    }

    func testFormatAssetAmountFromDecimal() {
        let asset = try? rest.asset.get(bySymbol: .dct).debug().toBlocking().single()
        let raw = try? asset?.to(raw: 1)
        
        XCTAssertEqual(raw, 100000000)
    }

    func testFormatAssetAmountFromDecimalWhenSmallerThanPrecision() {
        let asset = try? rest.asset.get(bySymbol: .dct).debug().toBlocking().single()
        XCTAssertThrowsError(try asset?.to(raw: 0.00000000001))
    }
    
    func testFormatAssetAmountFromString() {
        let asset = try? rest.asset.get(bySymbol: .dct).debug().toBlocking().single()
        let raw = try? asset?.amount("1")
        
        XCTAssertEqual(raw, AssetAmount(100000000))
    }
    
    func testFormatAssetAmountFromDouble() {
        let asset = try? rest.asset.get(bySymbol: .dct).debug().toBlocking().single()
        let raw = try? asset?.amount(Double(1))
        
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
    
    func testChainObjectHashing() {
        let assets = try? rest.asset.getAll(bySymbols: [.aia, .alx, .dct]).debug().toBlocking().single()
        XCTAssertNotNil(assets)
        let a = [assets!, assets!].joined()
        
        XCTAssertTrue(Set(a).count == 3)
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
        ("testGetAssetsByBoundary", testGetAssetsByBoundary),
    ]

}
