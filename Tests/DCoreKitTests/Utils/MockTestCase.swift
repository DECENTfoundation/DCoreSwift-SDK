import XCTest
import Hippolyte

@testable import DCoreKit

class MockTestCase: XCTestCase {
    
    override func tearDown() {
        super.tearDown()
        Hippolyte.shared.stop()
    }
    
    func mock(using url: URLConvertible, data: Data, status: Int = 200) {
        Hippolyte.shared.add(stubbedRequest: Mock.build(using: url, data: data))
        Hippolyte.shared.start()
    }
}
