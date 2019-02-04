import XCTest
import RxSwift
import RxBlocking

@testable import DCoreKit

class HistoryApiTests: XCTestCase {
    
    private let rest = DCore.Sdk.create(forRest: "https://stagesocket.decentgo.com:8090/rpc")
    
    func testGetBalanceHistoryUsingRest() {
        let id = "1.2.17".dcore.chainObject!
    
        let result = try? rest.history.getBalanceHistory(for: id, assets: [DCore.Constant.dct]).toBlocking().single()
        XCTAssertNotNil(result)
    }
    
 
    
   
    static var allTests = [
        ("testGetBalanceHistoryUsingRest", testGetBalanceHistoryUsingRest),
        ]
}
