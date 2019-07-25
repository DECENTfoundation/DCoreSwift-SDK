import XCTest
import RxBlocking

@testable import DCoreKit

class ValidationApiTests: XCTestCase {
    
    func testVerifyAccountAuthorityUsingInvalidAddress() {
        let rest = DCore.Sdk.create(forRest: DCore.TestConstant.httpUrl)
        let id = "1.2.11368"
        let address = "DCT8Uh7Bk4Qk8uqEZhhwRLvqvJU8YNSQ3SeQ4mTSApWQW456s5dwD".dcore.address!
        let result = try? rest.validation.verifyAccountAuthority(byReference: id, key: address).debug().toBlocking().single()
        
        XCTAssertFalse(result ?? true)
    }
    
    func testVerifyAccountAuthorityUsingValidAddress() {
        let rest = DCore.Sdk.create(forRest: DCore.TestConstant.httpUrl)
        let id = "1.2.27"
        let address = "DCT5PwcSiigfTPTwubadt85enxMFC18TtVoti3gnTbG7TN9f9R3Fp".dcore.address!
        let result = try? rest.validation.verifyAccountAuthority(byReference: id, key: address).debug().toBlocking().single()
        
        XCTAssertFalse(result ?? true)
    }
    
    static var allTests = [
        ("testVerifyAccountAuthorityUsingInvalidAddress", testVerifyAccountAuthorityUsingInvalidAddress),
        ("testVerifyAccountAuthorityUsingValidAddress", testVerifyAccountAuthorityUsingValidAddress)
        ]
}
