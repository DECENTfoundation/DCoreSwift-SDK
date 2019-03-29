import XCTest
import RxSwift
import RxBlocking

@testable import DCoreKit

class MessagingApiTests: XCTestCase {
    
    private let wss = DCore.Sdk.create(forWss: "wss://stagesocket.decentgo.com:8090")
    private let restMain = DCore.Sdk.create(forRest: "https://api.decent.ch/rpc")
    
    func testGetAllResponsesUsingWss() {
        
        let result = try? wss.messaging.getAllResponses().debug().toBlocking().single()
        XCTAssertNotNil(result)
    }
    
    func testGetAllResponsesBySenderUsingWss() {
        
        let result = try? wss.messaging.getAllResponses("1.2.17").debug().toBlocking().single()
        XCTAssertNotNil(result)
    }
    
    func testGetAllResponsesOnMainnetUsingRest() {
        
        let result = try? restMain.messaging.getAllResponses().debug().toBlocking().single()
        XCTAssertNotNil(result)
    }
    
    
    static var allTests = [
        ("testGetAllResponsesUsingWss", testGetAllResponsesUsingWss),
        ("testGetAllResponsesOnMainnetUsingRest", testGetAllResponsesOnMainnetUsingRest),
        ]
}
