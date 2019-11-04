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
                let nftCount = try? wss.nft.countAllNft().debug().toBlocking().single()
                let nftDataCount = try? wss.nft.countAllNftData().debug().toBlocking().single()
                XCTAssertEqual(2, nftCount)
                XCTAssertEqual(1, nftDataCount)
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

    func testListNftData() {
        _ = try? wss.nft.issue(
            credentials: creds!, reference: PUPPY, to: creds!.accountId, data: Puppy(
                male: true, name: "Puppy", weight: 5, owner: "Owner"
        )).debug().toBlocking().single()
        _ = try? wss.nft.issue(
            credentials: creds!, reference: PUPPY, to: creds!.accountId, data: Puppy(
                male: true, name: "Puppy 2", weight: 5, owner: "Owner 2"
        )).debug().toBlocking().single()

        let puppies: [NftData<Puppy>]? = try? wss.nft.listData(byNftId: "1.10.1").debug().toBlocking().single()
        XCTAssertEqual("Puppy", puppies?[0].data?.name)
        XCTAssertEqual("Puppy 2", puppies?[1].data?.name)
    }

    func testListNftRelative() {
        let nfts = try? wss.nft.listAllRelative(byLower: "K").debug().toBlocking().single()
        XCTAssertEqual(KITTEN, nfts?[0].symbol)
        XCTAssertEqual(PUPPY, nfts?[1].symbol)
    }

    func testSearchNftHistory() {
        let operations = try? wss.nft.searchNftHistory(byNftDataId: "1.11.0").debug().toBlocking().single()
        XCTAssertTrue((operations?.count ?? 0) > 0)
    }

    func testUpdateNft() {
        let newMaxSupply: UInt32 = 20
        let update = try? wss.nft.update(
            credentials: creds!,
            reference: KITTEN,
            maxSupply: newMaxSupply,
            fixedMaxSupply: false,
            description: "A Kitten NFT"
        ).debug().toBlocking().single()
        XCTAssertNotNil(update)

        let kittenNft = try? wss.nft.get(byId: "1.10.0").debug().toBlocking().single()
        XCTAssertEqual(kittenNft?.options.maxSupply, newMaxSupply)
    }

    func testUpdateDataNft() {
        let newName = "Kittie"
        let newOwner = "Kitten owner"
        let update = try? wss.nft.updateData(
            credentials: creds!, id: "1.11.0", newData: Kitten(male: true, name: newName, weight: 5, owner: newOwner)
        ).debug().toBlocking().single()
        XCTAssertNotNil(update)

        let kitten: NftData<Kitten>? = try? wss.nft.getData(byId: "1.11.0").debug().toBlocking().single()
        XCTAssertEqual(kitten?.data?.name, newName)
        XCTAssertEqual(kitten?.data?.owner, newOwner)
    }

    func testTransferNft() {
        let transfer = try? wss.nft.transfer(
            credentials: creds!, to: "1.2.28", id: "1.11.0", memo: Memo("transfer")
        ).debug().toBlocking().single()
        XCTAssertNotNil(transfer)
    }

    static var allTests = [
        ("testGetNftById", testGetNftById),
        ("testGetNftByIdNonexisting", testGetNftByIdNonexisting),
        ("testGetAllNft", testGetAllNft),
        ("testGetNftByReferenceChainId", testGetNftByReferenceChainId),
        ("testGetNftByReferenceSymbol", testGetNftByReferenceSymbol),
        ("testGetNftDataRawById", testGetNftDataRawById),
        ("testGetNftDataByIdWithParsedModel", testGetNftDataByIdWithParsedModel),
        ("testListNftData", testListNftData),
        ("testListNftRelative", testListNftRelative),
        ("testSearchNftHistory", testSearchNftHistory),
        ("testUpdateNft", testUpdateNft),
        ("testUpdateDataNft", testUpdateDataNft),
        ("testTransferNft", testTransferNft),
        ]
}
