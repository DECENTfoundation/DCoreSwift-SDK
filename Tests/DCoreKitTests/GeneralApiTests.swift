import XCTest
import RxBlocking

@testable import DCoreKit

class GeneralApiTests: XCTestCase {
    
    private let wss = DCore.Sdk.create(forWss: "wss://testnet-api.dcore.io")
    
    func testChainIdUsingWss() {
        let id = try? wss.general.getChainId().debug().toBlocking().single()
        XCTAssertEqual(id, "a76a2db75f7a8018d41f2d648c766fdb0ddc79ac77104d243074ebdd5186bfbe")
    }
    
    func testDynamicGlobalPropsUsingWss() {
        let props = try? wss.general.getDynamicGlobalProperties().debug().toBlocking().single()
        XCTAssertNotNil(props)
    }
    
    func testGlobalPropertiesUsingWss() {
        let props = try? wss.general.getGlobalProperties().debug().toBlocking().single()
        XCTAssertNotNil(props)
    }
    
    static var allTests = [
        ("testChainIdUsingWss", testChainIdUsingWss),
        ("testDynamicGlobalPropsUsingWss", testDynamicGlobalPropsUsingWss),
        ("testGlobalPropertiesUsingWss", testGlobalPropertiesUsingWss),
    ]
}
