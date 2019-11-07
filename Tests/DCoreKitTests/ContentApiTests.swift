import XCTest
import RxBlocking

@testable import DCoreKit

class ContentApiTests: XCTestCase {
    
    private let wss = DCore.Sdk.create(forWss: DCore.TestConstant.wsUrl)
    
    override func setUp() {
        super.setUp()
        DCore.Logger.xcode(filterCategories: [.network])
    }

    func testSubmitCdnContentOperationAndRemove() {
        let creds = try? Credentials(
            "1.2.27".asObjectId(), wif: "5Hxwqx6JJUBYWjQNt8DomTNJ6r6YK8wDJym4CMAH1zGctFyQtzt"
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

        let content = try? wss.content.get(byReference: uri)
            .debug()
            .toBlocking()
            .single()
        XCTAssertNotNil(content)

        let remove = try? wss.content.delete(byReference: uri, author: creds!).debug().toBlocking().single()
        XCTAssertNotNil(remove)
    }

     func testUpdateContentOperation() {
        let creds = try? Credentials(
            "1.2.27".asObjectId(), wif: "5Hxwqx6JJUBYWjQNt8DomTNJ6r6YK8wDJym4CMAH1zGctFyQtzt"
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

        let update = try? wss.content.update(
            on: uri,
            synopsis: Synopsis(title: "foofoo", description: "barbar"),
            price: AssetAmount(110000),
            coAuthors: [Pair("1.2.28".asObjectId(), 1000)],
            credentials: creds!,
            fee: .unset).debug().toBlocking().single()
        XCTAssertNotNil(update)
     }

    static var allTests = [
        ("testSubmitCdnContentOperationAndRemove", testSubmitCdnContentOperationAndRemove),
        ("testUpdateContentOperation", testUpdateContentOperation),
        ]
}
