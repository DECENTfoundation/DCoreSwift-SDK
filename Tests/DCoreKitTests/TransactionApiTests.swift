import XCTest
import RxSwift
import RxBlocking

@testable import DCoreKit

class TransactionApiTests: XCTestCase {

    private let rest = DCore.Sdk.create(forRest: DCore.TestConstant.httpUrl)

    func testGetTransaction() {
        let transaction = try? rest.history.get(byAccountId: "1.2.27", operationId: "1.7.0")
            .flatMap { self.rest.transaction.get(byBlockNum: $0.history.blockNum, positionInBlock: 0) }
            .flatMap { self.rest.transaction.get(byId: $0.id) }
            .toBlocking()
            .single()
        XCTAssertNotNil(transaction)
    }

    static var allTests = [
        ("testGetTransaction", testGetTransaction),
    ]
}
