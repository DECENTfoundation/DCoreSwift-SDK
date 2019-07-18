import XCTest
import RxSwift
import RxBlocking

@testable import DCoreKit

class HistoryApiTests: XCTestCase {
    
    private let rest = DCore.Sdk.create(forRest: DCore.TestConstant.httpUrl)
    private let wss = DCore.Sdk.create(forWss: DCore.TestConstant.wsUrl)

    override func setUp() {
        super.setUp()

        let pk = "5JMpT5C75rcAmuUB81mqVBXbmL1BKea4MYwVK6voMQLvigLKfrE"
        let creds = try? Credentials("1.2.28".dcore.chainObject!, wif: pk)
        _ = try? wss.account.transfer(from: creds!, to: "1.2.27", amount: AssetAmount(1)).toBlocking().single()
    }
    
    func testGetBalanceHistoryUsingWss() {
        let id = "1.2.28".dcore.chainObject!
    
        let result = try? wss.history.findAll(byAccountId: id).toBlocking().single()
        XCTAssertNotNil(result)
    }
    
    func testGetBalanceHistoryCheckTransferUsingRest() {
        let id = "1.2.28".dcore.chainObject!
        
        let result = try? rest.history.findAll(byAccountId: id,
                                               assets: [DCore.Constant.dct],
                                               recipientId: nil,
                                               pagination: (.ignore as Pagination).update(limit:2000)
        ).toBlocking().single()
        XCTAssertNotNil(result)
        XCTAssert(!result!.isEmpty)
        XCTAssert(result!.first!.history.operation.is(type: TransferOperation.self))
    }
    
    static var allTests = [
        ("testGetBalanceHistoryUsingWss", testGetBalanceHistoryUsingWss),
        ("testGetBalanceHistoryCheckTransferUsingRest", testGetBalanceHistoryCheckTransferUsingRest),
        ]
}
