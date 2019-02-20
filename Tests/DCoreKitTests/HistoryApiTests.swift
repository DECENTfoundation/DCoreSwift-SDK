import XCTest
import RxSwift
import RxBlocking

@testable import DCoreKit

class HistoryApiTests: XCTestCase {
    
    private let rest = DCore.Sdk.create(forRest: "https://stagesocket.decentgo.com:8090/rpc")
    private let wss = DCore.Sdk.create(forWss: "wss://stagesocket.decentgo.com:8090")
    
    func testGetBalanceHistoryUsingWss() {
        let id = "1.2.17".dcore.chainObject!
    
        let result = try? wss.history.getBalanceHistory(for: id).toBlocking().single()
        XCTAssertNotNil(result)
    }
    
    func testGetBalanceHistoryCheckTransferUsingRest() {
        let id = "1.2.17".dcore.chainObject!
        
        let result = try? rest.history.getBalanceHistory(for: id, assets: [DCore.Constant.dct]).toBlocking().single()
        XCTAssertNotNil(result)
        XCTAssert(!result!.isEmpty)
        XCTAssert(result!.first!.history.operation.is(type: TransferOperation.self))
    }
    
    static var allTests = [
        ("testGetBalanceHistoryUsingWss", testGetBalanceHistoryUsingWss),
        ("testGetBalanceHistoryCheckTransferUsingRest", testGetBalanceHistoryCheckTransferUsingRest),
        ]
}
