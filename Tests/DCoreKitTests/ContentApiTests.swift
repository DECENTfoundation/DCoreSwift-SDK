import XCTest
import RxBlocking

@testable import DCoreKit

class ContentApiTests: XCTestCase {
    
    private let wss = DCore.Sdk.create(forWss: "wss://testnet-api.dcore.io")
    
    override func setUp() {
        super.setUp()
        DCore.Logger.xcode(filterCategories: [.network])
    }

    func testSubmitCdnContentOperation() {
        let creds = try? Credentials(
            "1.2.27".asChainObject(), wif: "5Hxwqx6JJUBYWjQNt8DomTNJ6r6YK8wDJym4CMAH1zGctFyQtzt"
        )
        let uri = "https://foofoo.com/foo?v\(UUID().uuidString)"
        let exp = NSCalendar.current.date(byAdding: .month, value: 10, to: Date())!
        let syn = Synopsis(title: "foofofo", description: "foafa")
        
        let confirm = try? wss.content.create(
            on: .cdn(url: uri, expiration: exp, synopsis: syn),
            author: creds!,
            publishingFee: .unset,
            fee: .unset).debug().toBlocking().single()
        XCTAssertNotNil(confirm)
    }

     func testSubmitCdnWithPriceContentOperation() {
        let creds = try? Credentials(
            "1.2.27".asChainObject(), wif: "5Hxwqx6JJUBYWjQNt8DomTNJ6r6YK8wDJym4CMAH1zGctFyQtzt"
        )
        let uri = "https://foofoo.com/foo?v\(UUID().uuidString)"
        let exp = NSCalendar.current.date(byAdding: .month, value: 10, to: Date())!
        let syn = Synopsis(title: "foofofo", description: "foafa")
        let price = AssetAmount(100000)
     
        let confirm = try? wss.content.create(
            on: .cdnWithPrice(url: uri, expiration: exp, price: price, synopsis: syn),
            author: creds!,
            publishingFee: .unset,
            fee: .unset).debug().toBlocking().single()
        XCTAssertNotNil(confirm)
     }

    static var allTests = [
        ("testSubmitCdnContentOperation", testSubmitCdnContentOperation),
        ("testSubmitCdnWithPriceContentOperation", testSubmitCdnWithPriceContentOperation),
        ]
}
