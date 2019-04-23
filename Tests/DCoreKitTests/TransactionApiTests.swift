import XCTest
import RxSwift
import RxBlocking

@testable import DCoreKit

class TransactionApiTests: XCTestCase {

    private let restMain = DCore.Sdk.create(forRest: "https://api.decent.ch/rpc")

    func testGetTransactionByBlockOnMainnetUsingRest() {
        let result = try? restMain.transaction.get(byBlockNum: 11343032, positionInBlock: 0).toBlocking().single().id
        XCTAssertEqual("2e81adea1469bbb62ef1bd4581d5399c66f33ba9", result)
    }

    static var allTests = [
        ("testGetTransactionByBlockOnMainnetUsingRest", testGetTransactionByBlockOnMainnetUsingRest),
    ]
}
