import XCTest
import RxBlocking


@testable import DcoreKit

final class AssetApiTests: XCTestCase {

    private var api = DCore.Sdk.create(forRest: "https://stagesocket.decentgo.com:8090/rpc")
    
    func testGetAssetById() {
        let asset = try? api.asset.getAsset(byId: "1.3.0".chain.chainObject!).debug().toBlocking().single()
        XCTAssertEqual(asset?.id, DCore.Constant.Default.dct)
    }
    
    func testGetAssetBySymbol() {
        let asset = try? api.asset.getAsset(bySymbol: .dct).debug().toBlocking().single()
        XCTAssertEqual(asset?.id, DCore.Constant.Default.dct)
    }
    
    func testGetAssetsBySymbols() {
        let assets = try? api.asset.getAssets(bySymbols: [.alat, .alxt, .dct]).debug().toBlocking().single()
        XCTAssertEqual(assets?.count, 3)
    }
   
    
    static var allTests = [
        ("testGetAssetById", testGetAssetById),
        ("testGetAssetBySymbol", testGetAssetBySymbol),
    ]

}
