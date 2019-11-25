import XCTest
import BigInt

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
        let creds = try? Credentials("1.2.35".dcore.objectId()!, encryptedWif: wif, passphrase: pass)
        
        XCTAssertEqual(creds?.keyPair, "5Jd7zdvxXYNdUfnEXt5XokrE3zwJSs734yQ36a1YaqioRTGGLtn".dcore.keyPair)
    }
    
    func testCredentialFromEncryptedWifFailToDecrypt() {
        let wif = "d2c7e8dd3e34265f7959dfbdb780381f4e2e51ac215b57b94826c18c108e3cd426392b5ccd12bbf9c6a70a6bbe99fc433eaa051d27d25d698b184d4f8d7f7025"
        let pass = "wrong password"
    
        XCTAssertThrowsError(
            try Credentials("1.2.35".dcore.objectId()!, encryptedWif: wif, passphrase: pass)
        )
    }

    func testCredentialFromInvalidWifFailToDecode() {
        XCTAssertThrowsError(try Credentials("1.2.35".dcore.objectId()!, wif: "d23"))
    }

    func testValidateSignedTransaction() {
        let pk = "5J1HnqK3gajNzDWj9Na6fo3gxtphv6MHLE5YLgRmQv8tC8e3rEd"
        let creds = try! Credentials("1.2.17".dcore.objectId()!, wif: pk)
        
        let transaction = Transaction.init(
            BlockData(
                refBlockNum: 1,
                refBlockPrefix: 1,
                expiration: 1
            ),
            operations: [
                TransferOperation(
                    from: creds.accountId,
                    to: "1.2.34".dcore.objectId()!,
                    amount: AssetAmount(1),
                    memo: try! Memo("Ahoj", keyPair: nil, recipient: nil, nonce: 0),
                    fee: AssetAmount.unset
                )
            ],
            chainId: ""
        )
        
        let expectedSignature = "200f83f6752e815f1524ba9975bbcf5951a129119a2116f303af23781f8dc170217dddca3435d4cffa727f1470fa8670631fc66a44422b84cb4ac88de54399a703"
        let signedTransaction = try! transaction.with(signature: creds.keyPair)
        
        XCTAssertEqual(1, signedTransaction.signatures?.count)
        XCTAssertEqual(expectedSignature, signedTransaction.signatures?.first)
    }
    
    func testDecryptPublicMemo() {
        let plain = "hello memo here i am"
        let key = "5Jd7zdvxXYNdUfnEXt5XokrE3zwJSs734yQ36a1YaqioRTGGLtn".dcore.keyPair!
        let memo = try! Memo(plain)
        
        let result = try? memo.decrypt(key)
        XCTAssertTrue(result?.message == plain)
    }
    
    func testDecryptPrivateMemo() {
        let encrypted = "b23f6afb8eb463704d3d752b1fd8fb804c0ce32ba8d18eeffc20a2312e7c60fa"
        let plain = "hello memo here i am"
        let nonce = BigInt("10872523688190906880")
        let to = "DCT6bVmimtYSvWQtwdrkVVQGHkVsTJZVKtBiUqf4YmJnrJPnk89QP".dcore.address!
        let key = "5Jd7zdvxXYNdUfnEXt5XokrE3zwJSs734yQ36a1YaqioRTGGLtn".dcore.keyPair!
        
        let memo = try! Memo(plain, keyPair: key, recipient: to, nonce: nonce)
        
        XCTAssertTrue(memo.message == encrypted)
        
        let result = try? memo.decrypt(key)
        XCTAssertTrue(result?.message == plain)
    }
    
    static var allTests = [
        ("testAddress", testAddress),
        ("testKeyPair", testKeyPair),
        ("testKeyPairToAddress", testKeyPairToAddress),
        ("testCredentialFromEncryptedWif", testCredentialFromEncryptedWif),
        ("testCredentialFromEncryptedWifFailToDecrypt", testCredentialFromEncryptedWifFailToDecrypt),
        ("testValidateSignedTransaction", testValidateSignedTransaction),
        ("testDecryptPublicMemo", testDecryptPublicMemo),
        ("testDecryptPrivateMemo", testDecryptPrivateMemo),
    ]
}
