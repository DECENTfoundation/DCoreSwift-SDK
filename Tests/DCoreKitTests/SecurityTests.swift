import XCTest
import RxSwift
import RxBlocking

@testable import DCoreKit

class SecurityTests: XCTestCase {
    
    private let rest = DCore.Sdk.create(forRest: "https://api.decent.ch/rpc")
    private let wss = DCore.Sdk.create(forWss: "wss://api.decent.ch")
    
    func testPublicKeyServerTrustUsingRest() {
        let id = "1.2.17".dcore.chainObject!
        
        let validator = try? PublicKeysValidator(host: "decent.ch", pinnedKey: "")
        XCTAssertNotNil(validator)
        
        let result = try? wss.security.trusted(by: validator).history.getBalanceHistory(for: id).toBlocking().single()
        XCTAssertNotNil(result)
    }
    
    func testPublicKeyServerTrustUsingWss() {
        let id = "1.2.17".dcore.chainObject!
        
        let validator = try? PublicKeysValidator(host: "decent.ch", pinnedKey: "")
        XCTAssertNotNil(validator)
        
        let result = try? rest.security.trusted(by: validator).history.getBalanceHistory(for: id, assets: [DCore.Constant.dct]).toBlocking().single()
        XCTAssertNotNil(result)
    }
    
    static var allTests = [
        ("testPublicKeyServerTrustUsingRest", testPublicKeyServerTrustUsingRest),
        ("testPublicKeyServerTrustUsingWss", testPublicKeyServerTrustUsingWss),
    ]
}
