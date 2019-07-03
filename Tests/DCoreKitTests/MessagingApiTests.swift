import XCTest
import RxSwift
import RxBlocking

@testable import DCoreKit

class MessagingApiTests: XCTestCase {
    
    private let wss = DCore.Sdk.create(forWss: "wss://testnet-api.dcore.io")

    func testGetAllMessagesByReceiverUsingWss() {
        
        let result = try? wss.messaging.getAll(byReceiver: "1.2.28").debug().toBlocking().single()
        XCTAssertNotNil(result)
    }
    
    func testGetAllMessagesBySenderUsingWss() {
        
        let result = try? wss.messaging.getAll(bySender: "1.2.27").debug().toBlocking().single()
        XCTAssertNotNil(result)
    }

    func testGetAllResponsesByReceiverUsingWss() {

        let result = try? wss.messaging.getAllResponses(byReceiver: "1.2.28").debug().toBlocking().single()
        XCTAssertTrue(!(result?.isEmpty ?? true))
    }
    
    func testGetAllResponsesBySenderUsingWss() {

        let result = try? wss.messaging.getAllResponses(bySender: "1.2.27").debug().toBlocking().single()
        XCTAssertTrue(!(result?.isEmpty ?? true))
    }

    func testGetAllDecryptedMessagesByReceiverUsingWss() {
        
        let result = try? wss.messaging.getAllReceiverDecrypted(
            Credentials("1.2.28".asChainObject(), wif: "5JMpT5C75rcAmuUB81mqVBXbmL1BKea4MYwVK6voMQLvigLKfrE")
            ).debug().toBlocking().single()
        XCTAssertTrue(!(result?.isEmpty ?? true))
    }

    func testGetAllDecryptedMessagesBySenderUsingWss() {
        
        let result = try? wss.messaging.getAllSenderDecrypted(
            Credentials("1.2.27".asChainObject(), wif: "5Hxwqx6JJUBYWjQNt8DomTNJ6r6YK8wDJym4CMAH1zGctFyQtzt")
        ).debug().toBlocking().single()
        XCTAssertTrue(!(result?.isEmpty ?? true))
    }

    func testGetAllDecryptedMessagesBySenderUsingWrongCredentialsUsingWss() {
        
        let result = try? wss.messaging.getAllSenderDecrypted(
            Credentials("1.2.27".asChainObject(), wif: "5JMpT5C75rcAmuUB81mqVBXbmL1BKea4MYwVK6voMQLvigLKfrE")
            ).debug().toBlocking().single()
        XCTAssertTrue(result?.isEmpty ?? false)
    }

    func testSendUnencryptedMessage() {
        let result = try? wss.messaging.sendUnencrypted(
            to: "1.2.28",
            message: "test123",
            credentials: Credentials(
                "1.2.27".asChainObject(), wif: "5Hxwqx6JJUBYWjQNt8DomTNJ6r6YK8wDJym4CMAH1zGctFyQtzt"
            )
        ).debug().toBlocking().single()
        XCTAssertNotNil(result)
    }

    func testSendEncryptedMessage() {
        let result = try? wss.messaging.send(
            to: "1.2.28",
            message: "testEncrypted",
            credentials: Credentials(
                "1.2.27".asChainObject(), wif: "5Hxwqx6JJUBYWjQNt8DomTNJ6r6YK8wDJym4CMAH1zGctFyQtzt"
            )
        ).debug().toBlocking().single()
        XCTAssertNotNil(result)
    }
    
    static var allTests = [
        ("testGetAllMessagesByReceiverUsingWss", testGetAllMessagesByReceiverUsingWss),
        ("testGetAllMessagesBySenderUsingWss", testGetAllMessagesBySenderUsingWss),
        ("testGetAllResponsesByReceiverUsingWss", testGetAllResponsesByReceiverUsingWss),
        ("testGetAllResponsesBySenderUsingWss", testGetAllResponsesBySenderUsingWss),
        ("testGetAllDecryptedMessagesBySenderUsingWss", testGetAllDecryptedMessagesBySenderUsingWss),
        ("testGetAllDecryptedMessagesBySenderUsingWrongCredentialsUsingWss", testGetAllDecryptedMessagesBySenderUsingWrongCredentialsUsingWss),
        ("testSendUnencryptedMessage", testSendUnencryptedMessage),
        ]
}
