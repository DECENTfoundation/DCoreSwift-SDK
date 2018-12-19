import XCTest
@testable import DcoreKit

final class CryptoTests: XCTestCase {
    func testAddress() {
        let value = "DCT6bVmimtYSvWQtwdrkVVQGHkVsTJZVKtBiUqf4YmJnrJPnk89QP"
        let address = value.address
        
        XCTAssertEqual(address?.description, value)
    }
    
    static var allTests = [
        ("testAddress", testAddress),
    ]
}
