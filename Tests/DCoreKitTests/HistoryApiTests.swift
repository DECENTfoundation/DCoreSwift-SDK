import XCTest
import RxBlocking

@testable import DCoreKit

class HistoryApiTests: XCTestCase {
    
    private let rest = DCore.Sdk.create(forRest: "https://stagesocket.decentgo.com:8090/rpc")
    
    func testGetAnyBalanceHistoryUsingRest() {
        let id = "1.2.17".dcore.chainObject!
    
        let result = try? rest.history.getAnyBalanceHistory(for: id, assets: [DCore.Constant.dct]).debug().toBlocking().single()
        XCTAssert(true)
    }
    
   
    static var allTests = [
        ("testGetAnyBalanceHistoryUsingRest", testGetAnyBalanceHistoryUsingRest),
        ]
}
