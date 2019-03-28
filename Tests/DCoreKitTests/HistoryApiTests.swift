import XCTest
import RxSwift
import RxBlocking

@testable import DCoreKit

class HistoryApiTests: XCTestCase {
    
    private let rest = DCore.Sdk.create(forRest: "https://stagesocket.decentgo.com:8090/rpc")
    private let wss = DCore.Sdk.create(forWss: "wss://stagesocket.decentgo.com:8090")
    private let restMain = DCore.Sdk.create(forRest: "https://api.decent.ch/rpc")
    
    func testGetBalanceHistoryUsingWss() {
        let id = "1.2.17".dcore.chainObject!
    
        let result = try? wss.history.findAll(byAccountId: id).toBlocking().single()
        XCTAssertNotNil(result)
    }
    
    func testGetBalanceHistoryCheckTransferUsingRest() {
        let id = "1.2.34".dcore.chainObject!
        
        let result = try? rest.history.findAll(byAccountId: id,
                                               assets: [DCore.Constant.dct],
                                               recipientId: nil,
                                               pagination: (.ignore as Pagination).update(limit:2000)
        ).toBlocking().single()
        XCTAssertNotNil(result)
        XCTAssert(!result!.isEmpty)
        XCTAssert(result!.first!.history.operation.is(type: TransferOperation.self))
    }
    
    func testGetBalanceHistoryCheckOnMainnetUsingRest() {
        let id = "1.2.479".dcore.chainObject!
        
        let result = try? restMain.history.findAll(byAccountId: id,
                                                   assets: [],
                                                   recipientId: nil,
                                                   pagination: (.ignore as Pagination).update(limit:2000)
            ).toBlocking().single()
        XCTAssertNotNil(result)
    }
    
    static var allTests = [
        ("testGetBalanceHistoryUsingWss", testGetBalanceHistoryUsingWss),
        ("testGetBalanceHistoryCheckTransferUsingRest", testGetBalanceHistoryCheckTransferUsingRest),
        ("testGetBalanceHistoryCheckOnMainnetUsingRest", testGetBalanceHistoryCheckOnMainnetUsingRest),
        ]
}
