import XCTest
import RxSwift
import RxBlocking

@testable import DCoreKit

class SecurityTests: XCTestCase {
    
    private let rest = DCore.Sdk.create(forRest: "https://api.decent.ch/rpc")
    private let wss = DCore.Sdk.create(forWss: "wss://api.decent.ch")
    
    func testStandardServerTrustUsingRest() {
        let id = "1.2.11368".dcore.chainObject!
        let validator = StandardValidator()
        XCTAssertNotNil(validator)
        
        let result = try? rest.security.trusted(by: validator).history.getBalanceHistory(for: id).toBlocking().single()
        XCTAssertNotNil(result)
    }
    
    func testCertificatePinServerTrustUsingRest() {
        let id = "1.2.11368".dcore.chainObject!
        
        let validator = CertificatePinValidator(pin: Pair("api.decent.ch", "YivQjKihLWYpXWlacN7pYXyt+DzbTLep4vGrg4jBSZA="))
        XCTAssertNotNil(validator)
        
        let result = try? wss.security.trusted(by: validator).history.getBalanceHistory(for: id).toBlocking().single()
        XCTAssertNotNil(result)
    }
    
    func testCertificatePinServerTrustUsingWss() {
        let id = "1.2.11368".dcore.chainObject!
        
        let validator = CertificatePinValidator(pin: Pair("api.decent.ch", "YivQjKihLWYpXWlacN7pYXyt+DzbTLep4vGrg4jBSZA="))
        XCTAssertNotNil(validator)
        
        let result = try? rest.security.trusted(by: validator).history.getBalanceHistory(for: id, assets: [DCore.Constant.dct]).toBlocking().single()
        XCTAssertNotNil(result)
    }
    
    static var allTests = [
        ("testStandardServerTrustUsingRest", testStandardServerTrustUsingRest),
        ("testCertificatePinServerTrustUsingRest", testCertificatePinServerTrustUsingRest),
        ("testCertificatePinServerTrustUsingWss", testCertificatePinServerTrustUsingWss),
    ]
}
