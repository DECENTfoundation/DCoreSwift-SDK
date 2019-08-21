import XCTest
import RxSwift
import RxBlocking

@testable import DCoreKit

class MessagingApiTests: XCTestCase {
    
    private let wss = DCore.Sdk.create(forWss: DCore.TestConstant.wsUrl)
    private let creds = try! Credentials(
        "1.2.27".asChainObject(), wif: "5Hxwqx6JJUBYWjQNt8DomTNJ6r6YK8wDJym4CMAH1zGctFyQtzt"
    )

    func sendUnencryptedMessage() {
        let result = try? wss.messaging.sendUnencrypted(
            to: "1.2.28",
            message: "test123",
            credentials: creds
        ).debug().toBlocking().single()
        XCTAssertNotNil(result)
    }
    
    func sendEncryptedMessage() {
        let result = try? wss.messaging.send(
            to: "1.2.28",
            message: "testEncrypted",
            credentials: creds
        ).debug().toBlocking().single()
        XCTAssertNotNil(result)
    }

    func testGetAllMessagesByReceiverUsingWss() {
        sendEncryptedMessage()
        sendUnencryptedMessage()
        let result = try? wss.messaging.getAll(byReceiver: "1.2.28").debug().toBlocking().single()
        XCTAssertNotNil(result)
    }
    
    func testGetAllMessagesBySenderUsingWss() {
        sendEncryptedMessage()
        sendUnencryptedMessage()
        let result = try? wss.messaging.getAll(bySender: "1.2.27").debug().toBlocking().single()
        XCTAssertNotNil(result)
    }

    func testGetAllResponsesByReceiverUsingWss() {
        sendEncryptedMessage()
        sendUnencryptedMessage()
        let result = try? wss.messaging.getAllResponses(byReceiver: "1.2.28").debug().toBlocking().single()
        XCTAssertTrue(!(result?.isEmpty ?? true))
    }
    
    func testGetAllResponsesBySenderUsingWss() {
        sendEncryptedMessage()
        sendUnencryptedMessage()
        let result = try? wss.messaging.getAllResponses(bySender: "1.2.27").debug().toBlocking().single()
        XCTAssertTrue(!(result?.isEmpty ?? true))
    }

    func testGetAllDecryptedMessagesByReceiverUsingWss() {
        sendEncryptedMessage()
        
        let result = try? wss.messaging.getAllReceiverDecrypted(
            Credentials("1.2.28".asChainObject(), wif: "5JMpT5C75rcAmuUB81mqVBXbmL1BKea4MYwVK6voMQLvigLKfrE")
        ).debug().toBlocking().single()
        XCTAssertTrue(!(result?.isEmpty ?? true))
    }

    func testGetAllDecryptedMessagesBySenderUsingWss() {
        sendEncryptedMessage()
        
        let result = try? wss.messaging.getAllSenderDecrypted(creds).debug().toBlocking().single()
        XCTAssertTrue(!(result?.isEmpty ?? true))
    }

    func testGetAllDecryptedMessagesBySenderUsingWrongCredentialsUsingWss() {
        sendEncryptedMessage()
        sendUnencryptedMessage()
        
        let correctCredentialsResult = try? wss.messaging.getAllSenderDecrypted(creds).debug().toBlocking().single()

        let wrongCredentialsResult = try? wss.messaging.getAllSenderDecrypted(
            Credentials("1.2.27".asChainObject(), wif: "5KNdLJzt6A5soo2RHBHbi7FksexxMGPh19gD75tfCwUKuEN2tth")
        ).debug().toBlocking().single()

        XCTAssertGreaterThan(correctCredentialsResult?.count ?? 0, wrongCredentialsResult?.count ?? 0)
    }
    
    static var allTests = [
        ("testGetAllMessagesByReceiverUsingWss", testGetAllMessagesByReceiverUsingWss),
        ("testGetAllMessagesBySenderUsingWss", testGetAllMessagesBySenderUsingWss),
        ("testGetAllResponsesByReceiverUsingWss", testGetAllResponsesByReceiverUsingWss),
        ("testGetAllResponsesBySenderUsingWss", testGetAllResponsesBySenderUsingWss),
        ("testGetAllDecryptedMessagesBySenderUsingWss", testGetAllDecryptedMessagesBySenderUsingWss),
        ("testGetAllDecryptedMessagesBySenderUsingWrongCredentialsUsingWss", testGetAllDecryptedMessagesBySenderUsingWrongCredentialsUsingWss),
    ]
}
