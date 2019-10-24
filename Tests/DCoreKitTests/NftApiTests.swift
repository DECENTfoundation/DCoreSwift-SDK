import XCTest
import RxBlocking

@testable import DCoreKit

class NftApiTests: XCTestCase {
    
    private let wss = DCore.Sdk.create(forWss: DCore.TestConstant.wsUrl)
    let creds = try? Credentials(
        "1.2.27".asChainObject(), wif: "5Hxwqx6JJUBYWjQNt8DomTNJ6r6YK8wDJym4CMAH1zGctFyQtzt"
    )
    
    override func setUp() {
        super.setUp()
        DCore.Logger.xcode(filterCategories: [.network])
    }

    func testCreateNft() {
        let create = try? wss.nft.create(
            credentials: creds!,
            symbol: "KITTEN",
            maxSupply: 10,
            fixedMaxSupply: false,
            description: "A kitten NFT",
            nftModel: Kitten.self,
            transferable: true).debug().toBlocking().single()
        XCTAssertNotNil(create)
    }

    static var allTests = [
        ("testCreateNft", testCreateNft),
        ]
}
