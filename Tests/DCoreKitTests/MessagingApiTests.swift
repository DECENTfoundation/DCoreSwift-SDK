import XCTest
import RxSwift
import RxBlocking

@testable import DCoreKit

class MessagingApiTests: XCTestCase {
    
    private let wss = DCore.Sdk.create(forWss: DCore.TestConstant.wsUrl)
    private let creds = try! Credentials(
        "1.2.27".asObjectId(), wif: "5Hxwqx6JJUBYWjQNt8DomTNJ6r6YK8wDJym4CMAH1zGctFyQtzt"
    )
    private let unencryptedMessage = "test123"
    private let encryptedMessage = "testEncrypted"

    @discardableResult func sendUnencryptedMessage() -> String {
        let result = try? wss.messaging.sendUnencrypted(
            to: "1.2.28",
            message: unencryptedMessage,
            credentials: creds
            ).debug().toBlocking().single()
        XCTAssertNotNil(result)
        if case .array(let outerArray) = result?.transaction.opResults {
            if case .array(let innerArray) = outerArray[0] {
                if case .string(let objectId) = innerArray[1] { return objectId }
            }
        }
        return ""
    }
    
    @discardableResult func sendEncryptedMessage() -> String {
        let result = try? wss.messaging.send(
            to: "1.2.28",
            message: encryptedMessage,
            credentials: creds
        ).debug().toBlocking().single()
        XCTAssertNotNil(result)
        if case .array(let outerArray) = result?.transaction.opResults {
            if case .array(let innerArray) = outerArray[0] {
                if case .string(let objectId) = innerArray[1] { return objectId }
            }
        }
        return ""
    }
    
    func testGetAllMessagesByIds() {
        var messageIds = [String]()
        messageIds.append(sendUnencryptedMessage())
        messageIds.append(sendUnencryptedMessage())
        let result = try? wss.messaging.getAll(byIds: messageIds).debug().toBlocking().single()
        XCTAssertEqual(result?.count, 2)
    }
    
    func testGetMessagesById() {
        let id = sendUnencryptedMessage()
        let result = try? wss.messaging.get(byId: id).debug().toBlocking().single()
        XCTAssertNotNil(result)
    }
    
    func testGetAllMessagesByIdsDecrypted() {
        var messageIds = [String]()
        messageIds.append(sendEncryptedMessage())
        messageIds.append(sendEncryptedMessage())
        let result = try? wss.messaging.getAllDecrypted(byIds: messageIds, credentials: creds).debug().toBlocking().single()
        XCTAssertEqual(result?.count, 2)
    }
    
    func testGetMessagesByIdDecrypted() {
        let id = sendEncryptedMessage()
        let result = try? wss.messaging.getDecrypted(byId: id, credentials: creds).debug().toBlocking().single()
        XCTAssertNotNil(result)
    }
    
    func testFindAllMessagesByReceiver() {
        sendEncryptedMessage()
        sendUnencryptedMessage()
        let result = try? wss.messaging.findAll(byReceiver: "1.2.28").debug().toBlocking().single()
        XCTAssertNotNil(result)
    }
    
    func testFindAllMessagesBySender() {
        sendEncryptedMessage()
        sendUnencryptedMessage()
        let result = try? wss.messaging.findAll(bySender: "1.2.27").debug().toBlocking().single()
        XCTAssertNotNil(result)
    }

    func testFindAllResponsesByReceiver() {
        sendEncryptedMessage()
        sendUnencryptedMessage()
        let result = try? wss.messaging.findAllResponses(byReceiver: "1.2.28").debug().toBlocking().single()
        XCTAssertTrue(!(result?.isEmpty ?? true))
    }
    
    func testFindAllResponsesBySender() {
        sendEncryptedMessage()
        sendUnencryptedMessage()
        let result = try? wss.messaging.findAllResponses(bySender: "1.2.27").debug().toBlocking().single()
        XCTAssertTrue(!(result?.isEmpty ?? true))
    }

    func testFindAllDecryptedMessagesByReceiver() {
        sendEncryptedMessage()
        
        let result = try? wss.messaging.findAllReceiverDecrypted(
            Credentials("1.2.28".asObjectId(), wif: "5JMpT5C75rcAmuUB81mqVBXbmL1BKea4MYwVK6voMQLvigLKfrE")
        ).debug().toBlocking().single()
        XCTAssertTrue(!(result?.isEmpty ?? true))
    }

    func testFindAllDecryptedMessagesBySender() {
        sendEncryptedMessage()
        sendUnencryptedMessage()
        
        let result = try? wss.messaging.findAllSenderDecrypted(creds).debug().toBlocking().single()
        XCTAssertGreaterThanOrEqual(result?.count ?? 0, 2) // 2 messages sent above in this test
        XCTAssertEqual(unencryptedMessage, result?.first?.message)
        XCTAssertEqual(encryptedMessage, result?[1].message)
    }

    func testFindAllDecryptedMessagesBySenderUsingWrongCredentials() {
        sendEncryptedMessage()
        sendUnencryptedMessage()
        
        let correctCredentialsResult = try? wss.messaging.findAllSenderDecrypted(creds).debug().toBlocking().single()

        let wrongCredentialsResult = try? wss.messaging.findAllSenderDecrypted(
            Credentials("1.2.27".asObjectId(), wif: "5KNdLJzt6A5soo2RHBHbi7FksexxMGPh19gD75tfCwUKuEN2tth")
        ).debug().toBlocking().single()

        XCTAssertGreaterThan(correctCredentialsResult?.count ?? 0, wrongCredentialsResult?.count ?? 0)
    }
    
    static var allTests = [
        ("testGetAllMessagesByIds", testGetAllMessagesByIds),
        ("testGetMessagesById", testGetMessagesById),
        ("testGetAllMessagesByIdsDecrypted", testGetAllMessagesByIdsDecrypted),
        ("testGetMessagesByIdDecrypted", testGetMessagesByIdDecrypted),
        ("testFindAllMessagesByReceiver", testFindAllMessagesByReceiver),
        ("testFindAllMessagesBySender", testFindAllMessagesBySender),
        ("testFindAllResponsesByReceiver", testFindAllResponsesByReceiver),
        ("testFindAllResponsesBySender", testFindAllResponsesBySender),
        ("testFindAllDecryptedMessagesBySender", testFindAllDecryptedMessagesBySender),
        ("testFindAllDecryptedMessagesBySenderUsingWrongCredentials", testFindAllDecryptedMessagesBySenderUsingWrongCredentials),
    ]
}
