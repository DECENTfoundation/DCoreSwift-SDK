import XCTest
import RxBlocking

@testable import DCoreKit

class NftApiTests: XCTestCase {
    
    private let wss = DCore.Sdk.create(forWss: DCore.TestConstant.wsUrl)
    let creds = try? Credentials(
        "1.2.27".asChainObject(), wif: "5Hxwqx6JJUBYWjQNt8DomTNJ6r6YK8wDJym4CMAH1zGctFyQtzt"
    )
    private let KITTEN = "KITTEN"
    private let PUPPY = "PUPPY"
    
    override func setUp() {
        super.setUp()
        DCore.Logger.xcode(filterCategories: [.network])

        do {
        _ = try wss.nft.get(byId: "1.10.0").debug().toBlocking().single()
        } catch {
            if error.asDCoreException() == DCoreException.network(.notFound) {
                let createKitten = try? wss.nft.create(
                    credentials: creds!,
                    symbol: KITTEN,
                    maxSupply: 10,
                    fixedMaxSupply: false,
                    description: "A kitten NFT",
                    nftModel: Kitten.self,
                    transferable: true).debug().toBlocking().single()
                let createPuppy = try? wss.nft.create(
                    credentials: creds!,
                    symbol: PUPPY,
                    maxSupply: 15,
                    fixedMaxSupply: true,
                    description: "A puppy NFT",
                    nftModel: Puppy.self,
                    transferable: true).debug().toBlocking().single()
                let issue = try? wss.nft.issue(
                    credentials: creds!,
                    reference: KITTEN,
                    to: creds!.accountId,
                    data: Kitten(male: true, name: "Mr. Cat", weight: 5, owner: "Owner"),
                    memo: Memo("memo")).debug().toBlocking().single()
                XCTAssertNotNil(createKitten)
                XCTAssertNotNil(createPuppy)
                XCTAssertNotNil(issue)
            } else {
                XCTAssert(false, "Unexpected error: \(error.asDCoreException())")
            }
        }
    }

    func testGetNftById() {
        let nft = try? wss.nft.get(byId: "1.10.0").debug().toBlocking().single()
        XCTAssertNotNil(nft)
        XCTAssertEqual(KITTEN, nft?.symbol)
    }

    func testGetNftByIdNonexisting() {
        do {
            _ = try wss.nft.get(byId: "1.10.153").debug().toBlocking().single()
            XCTAssert(false)
        } catch {
            XCTAssertEqual(error.asDCoreException(), DCoreException.network(.notFound))
        }
    }

    func testGetAllNft() {
        let nfts = try? wss.nft.getAll(byIds: ["1.10.0", "1.10.1"]).debug().toBlocking().single()
        XCTAssertTrue(nfts.or([]).count >= 2)
        XCTAssertEqual(KITTEN, nfts?.first?.symbol)
        XCTAssertEqual(PUPPY, nfts?[1].symbol)
    }

    func testGetNftByReferenceChainId() {
        let nft = try? wss.nft.get(byReference: "1.10.0").debug().toBlocking().single()
        XCTAssertNotNil(nft)
        XCTAssertEqual(KITTEN, nft?.symbol)
    }

    func testGetNftByReferenceSymbol() {
        let nft = try? wss.nft.get(byReference: KITTEN).debug().toBlocking().single()
        XCTAssertNotNil(nft)
        XCTAssertEqual(KITTEN, nft?.symbol)
    }

    func testGetNftDataRawById() {
        let nftData = try? wss.nft.getDataRaw(byId: "1.11.0").debug().toBlocking().single()
        XCTAssertNotNil(nftData)
    }

    func testGetNftDataByIdWithParsedModel() {
        let kitten: NftData<Kitten>? = try? wss.nft.getData(byId: "1.11.0").debug().toBlocking().single()
        XCTAssertNotNil(kitten)
    }

    static var allTests = [
        ("testGetNftById", testGetNftById),
        ("testGetNftByIdNonexisting", testGetNftByIdNonexisting),
        ("testGetAllNft", testGetAllNft),
        ("testGetNftByReferenceChainId", testGetNftByReferenceChainId),
        ("testGetNftByReferenceSymbol", testGetNftByReferenceSymbol),
        ("testGetNftDataRawById", testGetNftDataRawById),
        ("testGetNftDataByIdWithParsedModel", testGetNftDataByIdWithParsedModel),
        ]
}
