import XCTest
import RxBlocking

@testable import DcoreKit

class SubscriptionApiTests: XCTestCase {

    private var rest: DCore.Api = DCore.Sdk.create(forRest: "https://stagesocket.decentgo.com:8090/rpc")
    
    func testSetBlockAppliedCallbackNotAllowedUsingRest() {
        XCTAssertThrowsError(
            try rest.subscription.setBlockAppliedCallback().debug().toBlocking().single()
        )
    }
    
    static var allTests = [
        ("testSetBlockAppliedCallbackNotAllowedUsingRest", testSetBlockAppliedCallbackNotAllowedUsingRest),
        ]
}
