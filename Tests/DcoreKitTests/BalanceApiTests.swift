import XCTest
import RxBlocking

@testable import DcoreKit

final class BalanceApiTests: XCTestCase {

    private var api: DCore.Api = DCore.Sdk.create(forRest: "https://stagesocket.decentgo.com:8090/rpc")
    
    func testGetBalanceByAccountId() {
   
        let balance = try? api.balance.getBalance(byAccountId: "1.2.34".chain.chainObject!).debug().toBlocking().single()
        XCTAssertEqual(balance?.asset.id, DCore.Constant.dct)
        XCTAssertEqual(balance?.amount.assetId, DCore.Constant.dct)
    }
    
    func testGetBalanceByAccountIdAndAssetId() {
        
        let balance = try? api.balance.getBalance(byAccountId: "1.2.34".chain.chainObject!, asset: DCore.Constant.dct).debug().toBlocking().single()
        XCTAssertEqual(balance?.assetId, DCore.Constant.dct)
    }
    
    static var allTests = [
        ("testGetBalanceByAccountId", testGetBalanceByAccountId),
        ("testGetBalanceByAccountIdAndAssetId", testGetBalanceByAccountIdAndAssetId),
    ]
}
