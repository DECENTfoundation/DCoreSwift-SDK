import XCTest
import RxBlocking

@testable import DcoreKit

class GeneralApiTests: XCTestCase {
    
    private var wss = DCore.Sdk.create(forWss: "wss://stagesocket.decentgo.com:8090")
    
    func testChainIdUsingWss() {
        let id = try? wss.general.getChainId().debug().toBlocking().single()
        XCTAssertEqual(id, "17401602b201b3c45a3ad98afc6fb458f91f519bd30d1058adf6f2bed66376bc")
    }
    
    func testDynamicGlobalPropsUsingWss() {
        let props = try? wss.general.getDynamicGlobalProperties().debug().toBlocking().single()
        XCTAssertNotNil(props)
    }
    
    static var allTests = [
        ("testChainIdUsingWss", testChainIdUsingWss),
        ("testDynamicGlobalPropsUsingWss", testDynamicGlobalPropsUsingWss),
    ]
}
