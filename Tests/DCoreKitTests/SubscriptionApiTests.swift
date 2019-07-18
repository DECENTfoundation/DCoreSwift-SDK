import XCTest
import RxBlocking

@testable import DCoreKit

class SubscriptionApiTests: XCTestCase {

    private let rest = DCore.Sdk.create(forRest: DCore.TestConstant.httpUrl)
    
    func testSetBlockAppliedCallbackNotAllowedUsingRest() {
        XCTAssertThrowsError(
            try rest.callback.onBlockApplied().debug().toBlocking().single()
        )
    }
    
    static var allTests = [
        ("testSetBlockAppliedCallbackNotAllowedUsingRest", testSetBlockAppliedCallbackNotAllowedUsingRest),
        ]
}
