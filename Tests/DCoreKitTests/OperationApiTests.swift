import XCTest
import RxBlocking

@testable import DCoreKit

class OperationApiTests: XCTestCase {

    private let wss = DCore.Sdk.create(forWss: DCore.TestConstant.wsUrl)
    
    override func setUp() {
        super.setUp()
        DCore.Logger.xcode(filterCategories: [.network])
    }
    
    func testTransferOperation() {
        let pk = "5JMpT5C75rcAmuUB81mqVBXbmL1BKea4MYwVK6voMQLvigLKfrE"
        let creds = try? Credentials("1.2.28".dcore.chainObject!, wif: pk)
        let confirm = try? wss.account.transfer(from: creds!, to: "1.2.22", amount: AssetAmount(1), message: "Ahoj",
                                                encrypted: false).debug().toBlocking().single()
        XCTAssertNotNil(confirm)
    }
    
    func testTransferOperationToChainObjectWithOtherVarInt() {
        let pk = "5JMpT5C75rcAmuUB81mqVBXbmL1BKea4MYwVK6voMQLvigLKfrE"
        let creds = try? Credentials("1.2.28".dcore.chainObject!, wif: pk)
        
        let confirm = try? wss.account.transfer(from: creds!, to: "1.2.22", amount: AssetAmount(1), message: "Ahoj",
                                                encrypted: false).debug().toBlocking().single()
        XCTAssertNotNil(confirm)
    }

    func testSubmitAccountOperation() {
        let pk = "5JMpT5C75rcAmuUB81mqVBXbmL1BKea4MYwVK6voMQLvigLKfrE"
        let creds = try? Credentials("1.2.28".dcore.chainObject!, wif: pk)
        let address = ECKeyPair().address
        let name = "ios\(CryptoUtils.secureRandom().prefix(upTo: 10).toHex())"
        
        let confirm = try? wss.account.create(.with(name: name, address: address), registrar: creds!).debug().toBlocking().single()
        XCTAssertNotNil(confirm)
    }

    func testUpdateAccountOperation() {
        let pk = "5Hxwqx6JJUBYWjQNt8DomTNJ6r6YK8wDJym4CMAH1zGctFyQtzt"
        let creds = try? Credentials("1.2.27".dcore.chainObject!, wif: pk)
        let newAuthority = "DCT5PwcSiigfTPTwubadt85enxMFC18TtVoti3gnTbG7TN9f9R3Fp"
        let confirm = try? wss.account.update(
            credentials: creds!, active: Authority(from: Address(from: newAuthority))
        ).debug().toBlocking().single()
        XCTAssertNotNil(confirm)
    }
    
    static var allTests = [
        ("testTransferOperation", testTransferOperation),
        ("testTransferOperationToChainObjectWithOtherVarInt", testTransferOperationToChainObjectWithOtherVarInt),
        ("testSubmitAccountOperation", testSubmitAccountOperation),
    ]
}
