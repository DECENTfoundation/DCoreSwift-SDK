import XCTest
import RxSwift
import RxBlocking

@testable import DCoreKit

class MessagingApiTests: XCTestCase {
    
    private let wss = DCore.Sdk.create(forWss: "wss://testnet-api.dcore.io")

    func testGetAllResponsesByReceiverUsingWss() {

        let result = try? wss.messaging.getAllResponses(byReceiver: "1.2.28").debug().toBlocking().single()
        XCTAssertNotNil(result)
    }
    
    func testGetAllResponsesBySenderUsingWss() {

        let result = try? wss.messaging.getAllResponses(bySender: "1.2.17").debug().toBlocking().single()
        XCTAssertNotNil(result)
    }
    
    static var allTests = [
        ("testGetAllResponsesByReceiverUsingWss", testGetAllResponsesByReceiverUsingWss),
        ("testGetAllResponsesBySenderUsingWss", testGetAllResponsesBySenderUsingWss),
        ]
}
