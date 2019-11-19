import XCTest
import RxBlocking

@testable import DCoreKit

class GeneralApiTests: XCTestCase {
    
    private let wss = DCore.Sdk.create(forWss: DCore.TestConstant.wsUrl)
    
    func testChainIdUsingWss() {
        let id = try? wss.general.getChainId().debug().toBlocking().single()
        XCTAssertEqual(id, "fdeb8d3eeedb7fbbcfed25d81318f1de7820a1056e3a864d14c520e5fafc4019")
    }
    
    func testDynamicGlobalPropsUsingWss() {
        let props = try? wss.general.getDynamicGlobalProperties().debug().toBlocking().single()
        XCTAssertNotNil(props)
    }
    
    func testGlobalPropertiesUsingWss() {
        let props = try? wss.general.getGlobalProperties().debug().toBlocking().single()
        XCTAssertNotNil(props)
    }

    func testGetConfiguration() {
        let config = try? wss.general.getConfiguration().debug().toBlocking().single()
        XCTAssertNotNil(config)
    }
    
    static var allTests = [
        ("testChainIdUsingWss", testChainIdUsingWss),
        ("testDynamicGlobalPropsUsingWss", testDynamicGlobalPropsUsingWss),
        ("testGlobalPropertiesUsingWss", testGlobalPropertiesUsingWss),
        ("testGetConfiguration", testGetConfiguration),
    ]
}
