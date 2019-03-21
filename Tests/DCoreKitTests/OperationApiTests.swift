import XCTest
import RxBlocking

@testable import DCoreKit

class OperationApiTests: XCTestCase {

    private let wss = DCore.Sdk.create(forWss: "wss://stagesocket.decentgo.com:8090")
    
    override func setUp() {
        super.setUp()
        DCore.Logger.xcode(filterCategories: [.network])
    }
    
    func testTransferOperation() {
        let pk = "5J1HnqK3gajNzDWj9Na6fo3gxtphv6MHLE5YLgRmQv8tC8e3rEd"
        let creds = try? Credentials("1.2.17".dcore.chainObject!, wif: pk)

        let op = SendMessageOperation("ahoj", payee: creds!.accountId)
        print(op.type)
        let confirm = try? wss.operation.transfer(creds!, to: "1.2.34", amount: AssetAmount(1), message: "Ahoj",
                                                  encrypted: false).debug().toBlocking().single()
        XCTAssertNotNil(confirm)
    }
    
    func testTransferOperationToChainObjectWithOtherVarInt() {
        let pk = "5J1HnqK3gajNzDWj9Na6fo3gxtphv6MHLE5YLgRmQv8tC8e3rEd"
        let creds = try? Credentials("1.2.17".dcore.chainObject!, wif: pk)
        
        let confirm = try? wss.operation.transfer(creds!, to: "1.2.687", amount: AssetAmount(1), message: "Ahoj",
                                                  encrypted: false).debug().toBlocking().single()
        XCTAssertNotNil(confirm)
    }
    
    func testSubmitCdnContentOperation() {
        let pk = "5J1HnqK3gajNzDWj9Na6fo3gxtphv6MHLE5YLgRmQv8tC8e3rEd"
        let creds = try? Credentials("1.2.17".dcore.chainObject!, wif: pk)
        let uri = "https://foofoo.com/foo?v\(UUID().uuidString)"
        let exp = NSCalendar.current.date(byAdding: .month, value: 10, to: Date())!
        let syn = Synopsis(title: "foofofo", description: "foafa")
        
        //let confirm = try? wss.content.create(on: .cdn(uri: uri, expiration: exp, synopsis: syn), credentials: creds!, publishingFee: .unset, fee: unset).debug().toBlocking().single()
        //XCTAssertNotNil(confirm)
    }
    
    func testSubmitCdnWithPriceContentOperation() {
        let pk = "5J1HnqK3gajNzDWj9Na6fo3gxtphv6MHLE5YLgRmQv8tC8e3rEd"
        let creds = try? Credentials("1.2.17".dcore.chainObject!, wif: pk)
        let uri = "https://foofoo.com/foo?v\(UUID().uuidString)"
        let exp = NSCalendar.current.date(byAdding: .month, value: 10, to: Date())!
        let syn = Synopsis(title: "foofofo", description: "foafa")
        let price = AssetAmount(100000)
        
        //let confirm = try? wss.content.create(on: .cdnWithPrice(uri: uri, expiration: exp, price: price, synopsis: syn), credentials: creds!, publishingFee: .unset, fee: unset).debug().toBlocking().single()
        //XCTAssertNotNil(confirm)
    }

    func testSubmitAccountOperation() {
        let pk = "5J1HnqK3gajNzDWj9Na6fo3gxtphv6MHLE5YLgRmQv8tC8e3rEd"
        let creds = try? Credentials("1.2.17".dcore.chainObject!, wif: pk)
        let address = ECKeyPair().address
        let name = "ios\(CryptoUtils.secureRandom().prefix(upTo: 10).toHex())"
        
        let confirm = try? wss.account.create(.with(name: name, address: address), registrar: creds!).debug().toBlocking().single()
        XCTAssertNotNil(confirm)
    }
    
    static var allTests = [
        ("testTransferOperation", testTransferOperation),
        ("testTransferOperationToChainObjectWithOtherVarInt", testTransferOperationToChainObjectWithOtherVarInt),
        ("testSubmitCdnContentOperation", testSubmitCdnContentOperation),
        ("testSubmitCdnWithPriceContentOperation", testSubmitCdnWithPriceContentOperation),
        ("testSubmitAccountOperation", testSubmitAccountOperation),
    ]
}
