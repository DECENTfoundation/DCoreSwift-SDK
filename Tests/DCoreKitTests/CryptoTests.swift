import XCTest
@testable import DCoreKit

final class CryptoTests: XCTestCase {
    func testAddress() {
        let value = "DCT6bVmimtYSvWQtwdrkVVQGHkVsTJZVKtBiUqf4YmJnrJPnk89QP"
        let address = value.dcore.address!
        
        XCTAssertEqual(address.description, value)
    }
    
    func testKeyPair() {
        
        let value = "5HvjjE1arorzNLdgRCUrhwzocDJWSdp4sLxSrSkTkA1pVwf9qzy"
        let kp = value.dcore.keyPair!
        
        XCTAssertEqual(kp.description, value)
    }
    
    func testKeyPairToAddress() {
        
        let value = "5HvjjE1arorzNLdgRCUrhwzocDJWSdp4sLxSrSkTkA1pVwf9qzy"
        let address = "DCT5mQypBKZvMsMACxkwpqDAgABFYYzRjMSMUWVVLog25cw2jwPHk"
        
        let kp = value.dcore.keyPair!
 
        XCTAssertEqual(kp.address.description, address)
    }
    
    func testCredentialFromEncryptedWif() {
        let wif = "d2c7e8dd3e34265f7959dfbdb780381f4e2e51ac215b57b94826c18c108e3cd426392b5ccd12bbf9c6a70a6bbe99fc433eaa051d27d25d698b184d4f8d7f7025"
        let pass = "quick brown fox jumped over a lazy dog"
        let creds = try? Credentials("1.2.35".dcore.chainObject!, encryptedWif: wif, passphrase: pass)
        
        XCTAssertEqual(creds?.keyPair, "5Jd7zdvxXYNdUfnEXt5XokrE3zwJSs734yQ36a1YaqioRTGGLtn".dcore.keyPair)
    }
    
    func testCredentialFromEncryptedWifFailToDecrypt() {
        let wif = "d2c7e8dd3e34265f7959dfbdb780381f4e2e51ac215b57b94826c18c108e3cd426392b5ccd12bbf9c6a70a6bbe99fc433eaa051d27d25d698b184d4f8d7f7025"
        let pass = "wrong password"
    
        XCTAssertThrowsError(
            try Credentials("1.2.35".dcore.chainObject!, encryptedWif: wif, passphrase: pass)
        )
    }
    
    static var allTests = [
        ("testAddress", testAddress),
        ("testKeyPair", testKeyPair),
        ("testKeyPairToAddress", testKeyPairToAddress),
        ("testCredentialFromEncryptedWif", testCredentialFromEncryptedWif),
        ("testCredentialFromEncryptedWifFailToDecrypt", testCredentialFromEncryptedWifFailToDecrypt),
    ]
}
