import XCTest
import RxBlocking

@testable import DCoreKit

final class AccountApiTests: XCTestCase {

    private let rest = DCore.Sdk.create(forRest: "https://testnet-api.dcore.io/rpc")
    private let wss = DCore.Sdk.create(forWss: "wss://testnet-api.dcore.io")
    
    func testGetAccountByNameUsingRest() {
        let account = try? rest.account.get(byName: "public-account-10").debug().toBlocking().single()
        XCTAssertEqual(account?.id, "1.2.28".dcore.chainObject)
    }
    
    func testGetAccountByIdUsingRest() {
        let account = try? rest.account.get(byId: "1.2.28").debug().toBlocking().single()
        XCTAssertEqual(account?.id, "1.2.28".dcore.chainObject)
    }
    
    func testGetAccountByReferenceUsingRest() {
        let account = try? rest.account.get(byReference: "1.2.28").debug().toBlocking().single()
        XCTAssertEqual(account?.name, "public-account-10")
    }

    func testGetAccountByInvalidReferenceUsingRest() {
        XCTAssertThrowsError(try rest.account.get(byReference: "abc").debug().toBlocking().single())
    }
    
    func testGetAccountIdsByAddressUsingRest() {
        let ids = try? rest.account.findAllReferences(byKeys: ["DCT51ojM7TUGVpFNUJWX8wi5dYp4iA4brRG16zWfcteVZRZHnkWCF".dcore.address!]).debug().toBlocking().single()
        XCTAssert(ids?.first?.contains("1.2.28".dcore.chainObject!) ?? false)
    }
    
    func testGetAccountByIdsUsingRest() {
        let accounts = try? rest.account.getAll(byIds: ["1.2.27".dcore.chainObject!, "1.2.28".dcore.chainObject!]).debug().toBlocking().single()
        XCTAssert(Set(["1.2.27", "1.2.28"]).isSuperset(of: Set(accounts!.map({ $0.id.description }))))
    }
    
    func testGetAccountByNameAndIdUsingRest() {
        let account1 = try? rest.account.get(byName: "public-account-10").debug().toBlocking().single()
        let account2 = try? rest.account.get(byReference: "1.2.28").debug().toBlocking().single()
        XCTAssertEqual(account1?.id, account2?.id)
    }
    
    func testGetAccountByNameNotFoundUsingRest() {
        XCTAssertThrowsError(
            try rest.account.get(byName: "xxxxxxxx1234567").debug().toBlocking().single()
        ) { XCTAssertEqual($0.asDCoreException(), DCoreException.network(.notFound)) }
    }
    
    func testGetAccountByNameUsingWss() {
        let account = try? wss.account.get(byName: "public-account-10").debug().toBlocking().single()
        XCTAssertEqual(account?.id, "1.2.28".dcore.chainObject)
    }
    
    func testGetAccountByReferenceUsingWss() {
        let account = try? wss.account.get(byReference: "1.2.28").debug().toBlocking().single()
        XCTAssertEqual(account?.name, "public-account-10")
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
