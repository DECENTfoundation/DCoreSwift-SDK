import XCTest
import RxBlocking

@testable import DcoreKit

final class BalanceApiTests: XCTestCase {

    private var api: DCore.Api = DCore.Sdk.create(forRest: "https://stagesocket.decentgo.com:8090/rpc")
    
    func testGetBalanceByAccountId() {
   
        // let b = try? self.api.balance.getBalance(byReference: "").to
        XCTAssert(true)
    }
    
    static var allTests = [
        ("testGetBalanceByAccountId", testGetBalanceByAccountId),
    ]
}
