import XCTest
import RxBlocking

@testable import DCoreKit

class ValidationApiTests: XCTestCase {
    
    func testVerifyAccountAuthorityViaMainetCredsOnStageUsingRest() {
        let rest = DCore.Sdk.create(forRest: "https://stagesocket.decentgo.com:8090/rpc")
        let id = "1.2.11368"
        let address = "DCT8Uh7Bk4Qk8uqEZhhwRLvqvJU8YNSQ3SeQ4mTSApWQW456s5dwD".dcore.address!
        let result = try? rest.validation.verifyAccountAuthority(byReference: id, key: address).debug().toBlocking().single()
        
        XCTAssertFalse(result ?? true)
    }
    
    func testVerifyAccountAuthorityViaStageCredsOnMainetUsingRest() {
        let rest = DCore.Sdk.create(forRest: "https://socket.decentgo.com:8090/rpc")
        let id = "1.2.1564"
        let address = "DCT5fSPDaH5Pi9K1fFmTMGLXVVVGu9y96FimJhGdLTSxXCFmMhB3a".dcore.address!
        let result = try? rest.validation.verifyAccountAuthority(byReference: id, key: address).debug().toBlocking().single()
        
        XCTAssertFalse(result ?? true)
    }
    
    static var allTests = [
        ("testVerifyAccountAuthorityViaMainetCredsOnStageUsingRest", testVerifyAccountAuthorityViaMainetCredsOnStageUsingRest),
        ("testVerifyAccountAuthorityViaStageCredsOnMainetUsingRest", testVerifyAccountAuthorityViaStageCredsOnMainetUsingRest)
        ]
}
