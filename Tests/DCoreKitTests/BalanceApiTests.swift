import XCTest
import RxBlocking

@testable import DCoreKit

final class BalanceApiTests: XCTestCase {

    private let rest = DCore.Sdk.create(forRest: "https://stagesocket.decentgo.com:8090/rpc")
    private let restMain = DCore.Sdk.create(forRest: "https://api.decent.ch/rpc")
    
    func testGetBalanceByAccountId() {
   
        let balance = try? rest.balance.getWithAsset(byAccountId: "1.2.34".dcore.chainObject!).debug().toBlocking().single()
        XCTAssertEqual(balance?.asset.id, DCore.Constant.dct)
        XCTAssertEqual(balance?.amount.assetId, DCore.Constant.dct)
    }
    
    func testGetBalanceByAccountIdAndAssetId() {
        
        let balance = try? rest.balance.get(byAccountId: "1.2.34".dcore.chainObject!, asset: DCore.Constant.dct).debug().toBlocking().single()
        XCTAssertEqual(balance?.assetId, DCore.Constant.dct)
    }
    
    func testGetBalanceByAccountIdOnMainnet() {
        let id = "1.2.11368".dcore.chainObject!
        
        let balance = try? restMain.balance.getWithAsset(byAccountId: id).debug().toBlocking().single()
        XCTAssertEqual(balance?.asset.id, DCore.Constant.dct)
        XCTAssertEqual(balance?.amount.assetId, DCore.Constant.dct)
    }
    
    static var allTests = [
        ("testGetBalanceByAccountId", testGetBalanceByAccountId),
        ("testGetBalanceByAccountIdAndAssetId", testGetBalanceByAccountIdAndAssetId),
        ("testGetBalanceByAccountIdOnMainnet", testGetBalanceByAccountIdOnMainnet)
    ]
}
