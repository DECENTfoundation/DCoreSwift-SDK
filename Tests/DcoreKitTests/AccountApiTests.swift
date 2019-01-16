import XCTest
import RxBlocking

@testable import DcoreKit

final class AccountApiTests: XCTestCase {

    private var rest = DCore.Sdk.create(forRest: "https://stagesocket.decentgo.com:8090/rpc")
    private var wss = DCore.Sdk.create(forWss: "wss://stagesocket.decentgo.com:8090")
    
    func testGetAccountByNameUsingRest() {
        let account = try? rest.account.getAccount(byName: "u961279ec8b7ae7bd62f304f7c1c3d345").debug().toBlocking().single()
        XCTAssertEqual(account?.id, "1.2.34".chain.chainObject)
    }
    
    func testGetAccountByReferenceUsingRest() {
        let account = try? rest.account.getAccount(byReference: "1.2.34").debug().toBlocking().single()
        XCTAssertEqual(account?.name, "u961279ec8b7ae7bd62f304f7c1c3d345")
    }

    func testGetAccountByInvalidReferenceUsingRest() {
        XCTAssertThrowsError(try rest.account.getAccount(byReference: "abc").debug().toBlocking().single())
    }
    
    func testGetAccountByAddressUsingRest() {
        let account = try? rest.account.getAccount(byReference: "DCT6MA5TQQ6UbMyMaLPmPXE2Syh5G3ZVhv5SbFedqLPqdFChSeqTz").debug().toBlocking().single()
        XCTAssertEqual(account?.name, "u961279ec8b7ae7bd62f304f7c1c3d345")
    }
    
    func testGetAccountIdsByAddressUsingRest() {
        let ids = try? rest.account.getAccountIds(byAddressList: ["DCT6MA5TQQ6UbMyMaLPmPXE2Syh5G3ZVhv5SbFedqLPqdFChSeqTz".chain.address!]).debug().toBlocking().single()
        XCTAssert(ids?.first?.contains("1.2.34".chain.chainObject!) ?? false)
    }
    
    func testGetAccountByIdsUsingRest() {
        let accounts = try? rest.account.getAccounts(byIds: ["1.2.33".chain.chainObject!, "1.2.34".chain.chainObject!]).debug().toBlocking().single()
        XCTAssert(Set(["1.2.33", "1.2.34"]).isSuperset(of: Set(accounts!.map({ $0.id.description }))))
    }
    
    func testGetAccountByNameAndIdUsingRest() {
        let account1 = try? rest.account.getAccount(byName: "u961279ec8b7ae7bd62f304f7c1c3d345").debug().toBlocking().single()
        let account2 = try? rest.account.getAccount(byReference: "1.2.34").debug().toBlocking().single()
        XCTAssertEqual(account1?.id, account2?.id)
    }
    
    func testGetAccountByNameNotFoundUsingRest() {
        XCTAssertThrowsError(
            try rest.account.getAccount(byName: "xxxxxxxx1234567").debug().toBlocking().single()
        ) { XCTAssertEqual($0.asChainException(), ChainException.network(.notFound)) }
    }
    
    func testGetAccountByNameUsingWss() {
        let account = try? wss.account.getAccount(byName: "u961279ec8b7ae7bd62f304f7c1c3d345").debug().toBlocking().single()
        XCTAssertEqual(account?.id, "1.2.34".chain.chainObject)
    }
    
    func testGetAccountByReferenceUsingWss() {
        let account = try? wss.account.getAccount(byReference: "1.2.34").debug().toBlocking().single()
        XCTAssertEqual(account?.name, "u961279ec8b7ae7bd62f304f7c1c3d345")
    }
    
    func testGetAccountByAddressUsingWss() {
        let account = try? wss.account.getAccount(byReference: "DCT6MA5TQQ6UbMyMaLPmPXE2Syh5G3ZVhv5SbFedqLPqdFChSeqTz").debug().toBlocking().single()
        XCTAssertEqual(account?.name, "u961279ec8b7ae7bd62f304f7c1c3d345")
    }
    
    func testGetAccountByAddressNotFoundUsingWss() {
        XCTAssertThrowsError(
            try wss.account.getAccount(byName: "xxxxxxxx1234567").debug().toBlocking().single()
        ) { XCTAssertEqual($0.asChainException(), ChainException.network(.notFound)) }
    }
    
    static var allTests = [
        ("testGetAccountByNameUsingRest", testGetAccountByNameUsingRest),
        ("testGetAccountByReferenceUsingRest", testGetAccountByReferenceUsingRest),
        ("testGetAccountByInvalidReferenceUsingRest", testGetAccountByInvalidReferenceUsingRest),
        ("testGetAccountByAddressUsingRest", testGetAccountByAddressUsingRest),
        ("testGetAccountIdsByAddressUsingRest", testGetAccountIdsByAddressUsingRest),
        ("testGetAccountByIdsUsingRest", testGetAccountByIdsUsingRest),
        ("testGetAccountByNameAndIdUsingRest", testGetAccountByNameAndIdUsingRest),
        ("testGetAccountByNameNotFoundUsingRest", testGetAccountByNameNotFoundUsingRest),
        ("testGetAccountByNameUsingWss", testGetAccountByNameUsingWss),
        ("testGetAccountByReferenceUsingWss", testGetAccountByReferenceUsingWss),
        ("testGetAccountByAddressUsingWss", testGetAccountByAddressUsingWss),
    ]

}
