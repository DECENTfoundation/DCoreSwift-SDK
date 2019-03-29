import XCTest
import RxBlocking

@testable import DCoreKit

class SubscriptionApiTests: XCTestCase {

    private let rest = DCore.Sdk.create(forRest: "https://testnet-api.dcore.io/rpc")
    
    func testSetBlockAppliedCallbackNotAllowedUsingRest() {
        XCTAssertThrowsError(
            try rest.callback.onBlockApplied().debug().toBlocking().single()
        )
    }
    
    static var allTests = [
        ("testSetBlockAppliedCallbackNotAllowedUsingRest", testSetBlockAppliedCallbackNotAllowedUsingRest),
        ]
}
