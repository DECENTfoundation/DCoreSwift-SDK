import XCTest
import RxBlocking

@testable import DCoreKit

final class AccountApiTests: XCTestCase {

    private let rest = DCore.Sdk.create(forRest: "https://stagesocket.decentgo.com:8090/rpc")
    private let wss = DCore.Sdk.create(forWss: "wss://stagesocket.decentgo.com:8090")
    
    func testGetAccountByNameUsingRest() {
        let account = try? rest.account.get(byName: "u961279ec8b7ae7bd62f304f7c1c3d345").debug().toBlocking().single()
        XCTAssertEqual(account?.id, "1.2.34".dcore.chainObject)
    }
    
    func testGetAccountByIdUsingRest() {
        let account = try? rest.account.get(byId: "1.2.34").debug().toBlocking().single()
        XCTAssertEqual(account?.id, "1.2.34".dcore.chainObject)
    }
    
    func testGetAccountByReferenceUsingRest() {
        let account = try? rest.account.get(byReference: "1.2.34").debug().toBlocking().single()
        XCTAssertEqual(account?.name, "u961279ec8b7ae7bd62f304f7c1c3d345")
    }

    func testGetAccountByInvalidReferenceUsingRest() {
        XCTAssertThrowsError(try rest.account.get(byReference: "abc").debug().toBlocking().single())
    }
    
    func testGetAccountIdsByAddressUsingRest() {
        let ids = try? rest.account.findAllReferences(byKeys: ["DCT6MA5TQQ6UbMyMaLPmPXE2Syh5G3ZVhv5SbFedqLPqdFChSeqTz".dcore.address!]).debug().toBlocking().single()
        XCTAssert(ids?.first?.contains("1.2.34".dcore.chainObject!) ?? false)
    }
    
    func testGetAccountByIdsUsingRest() {
        let accounts = try? rest.account.getAll(byIds: ["1.2.33".dcore.chainObject!, "1.2.34".dcore.chainObject!]).debug().toBlocking().single()
        XCTAssert(Set(["1.2.33", "1.2.34"]).isSuperset(of: Set(accounts!.map({ $0.id.description }))))
    }
    
    func testGetAccountByNameAndIdUsingRest() {
        let account1 = try? rest.account.get(byName: "u961279ec8b7ae7bd62f304f7c1c3d345").debug().toBlocking().single()
        let account2 = try? rest.account.get(byReference: "1.2.34").debug().toBlocking().single()
        XCTAssertEqual(account1?.id, account2?.id)
    }
    
    func testGetAccountByNameNotFoundUsingRest() {
        XCTAssertThrowsError(
            try rest.account.get(byName: "xxxxxxxx1234567").debug().toBlocking().single()
        ) { XCTAssertEqual($0.asDCoreException(), DCoreException.network(.notFound)) }
    }
    
    func testGetAccountByNameUsingWss() {
        let account = try? wss.account.get(byName: "u961279ec8b7ae7bd62f304f7c1c3d345").debug().toBlocking().single()
        XCTAssertEqual(account?.id, "1.2.34".dcore.chainObject)
    }
    
    func testGetAccountByReferenceUsingWss() {
        let account = try? wss.account.get(byReference: "1.2.34").debug().toBlocking().single()
        XCTAssertEqual(account?.name, "u961279ec8b7ae7bd62f304f7c1c3d345")
    }
    
    func testGetAccountByAddressNotFoundUsingWss() {
        XCTAssertThrowsError(
            try wss.account.get(byName: "xxxxxxxx1234567").debug().toBlocking().single()
        ) { XCTAssertEqual($0.asDCoreException(), DCoreException.network(.notFound)) }
    }
    
    static var allTests = [
        ("testGetAccountByNameUsingRest", testGetAccountByNameUsingRest),
        ("testGetAccountByIdUsingRest", testGetAccountByIdUsingRest),
        ("testGetAccountByReferenceUsingRest", testGetAccountByReferenceUsingRest),
        ("testGetAccountByInvalidReferenceUsingRest", testGetAccountByInvalidReferenceUsingRest),
        ("testGetAccountIdsByAddressUsingRest", testGetAccountIdsByAddressUsingRest),
        ("testGetAccountByIdsUsingRest", testGetAccountByIdsUsingRest),
        ("testGetAccountByNameAndIdUsingRest", testGetAccountByNameAndIdUsingRest),
        ("testGetAccountByNameNotFoundUsingRest", testGetAccountByNameNotFoundUsingRest),
        ("testGetAccountByNameUsingWss", testGetAccountByNameUsingWss),
        ("testGetAccountByReferenceUsingWss", testGetAccountByReferenceUsingWss),
        ("testGetAccountByAddressNotFoundUsingWss", testGetAccountByAddressNotFoundUsingWss),
    ]

}
