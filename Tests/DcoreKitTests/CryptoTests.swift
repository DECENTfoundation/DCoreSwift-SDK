import XCTest
@testable import DcoreKit

final class CryptoTests: XCTestCase {
    func testAddress() {
        let value = "DCT6bVmimtYSvWQtwdrkVVQGHkVsTJZVKtBiUqf4YmJnrJPnk89QP"
        let address = value.address!
        
        XCTAssertEqual(address.description, value)
    }
    
    func testKeyPair() {
        
        let value = "5HvjjE1arorzNLdgRCUrhwzocDJWSdp4sLxSrSkTkA1pVwf9qzy"
        let kp = value.keyPair!
        
        XCTAssertEqual(kp.description, value)
    }
    
    func testKeyPairToAddress() throws {
        
        let value = "5HvjjE1arorzNLdgRCUrhwzocDJWSdp4sLxSrSkTkA1pVwf9qzy"
        let address = "DCT5mQypBKZvMsMACxkwpqDAgABFYYzRjMSMUWVVLog25cw2jwPHk"
        
        let kp = value.keyPair!
 
        XCTAssertEqual(kp.address.description, address)
    }
    
    static var allTests = [
        ("testAddress", testAddress),
        ("testKeyPair", testKeyPair),
        ("testKeyPairToAddress", testKeyPairToAddress),
    ]
}
