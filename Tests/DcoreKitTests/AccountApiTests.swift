import XCTest
import RxBlocking

@testable import DcoreKit

final class AccountApiTests: XCTestCase {

    private var api = DCore.Sdk.create(forRest: "https://stagesocket.decentgo.com:8090/rpc")
  
    func testGetAccountByName() {
        let account = try? api.account.getAccount(byName: "u961279ec8b7ae7bd62f304f7c1c3d345").debug().toBlocking().single()
        XCTAssertEqual(account?.id, "1.2.34".chain.chainObject)
    }
    
    func testGetAccountByReference() {
        let account = try? api.account.getAccount(byReference: "1.2.34").debug().toBlocking().single()
        XCTAssertEqual(account?.name, "u961279ec8b7ae7bd62f304f7c1c3d345")
    }
    
    func testGetAccountByAddress() {
        let account = try? api.account.getAccount(byReference: "DCT6MA5TQQ6UbMyMaLPmPXE2Syh5G3ZVhv5SbFedqLPqdFChSeqTz").debug().toBlocking().single()
        XCTAssertEqual(account?.name, "u961279ec8b7ae7bd62f304f7c1c3d345")
    }
    
    func testGetAccountIdsByAddress() {
        let ids = try? api.account.getAccountIds(byAddressList: ["DCT6MA5TQQ6UbMyMaLPmPXE2Syh5G3ZVhv5SbFedqLPqdFChSeqTz".chain.address!]).debug().toBlocking().single()
        XCTAssert(ids?.first?.contains("1.2.34".chain.chainObject!) ?? false)
    }
    
    func testGetAccountByIds() {
        let accounts = try? api.account.getAccounts(byIds: ["1.2.33".chain.chainObject!, "1.2.34".chain.chainObject!]).debug().toBlocking().single()
        XCTAssert(Set(["1.2.33", "1.2.34"]).isSuperset(of: Set(accounts!.map({ $0.id.description }))))
    }
    
    func testGetAccountByNameAndId() {
        let account1 = try? api.account.getAccount(byName: "u961279ec8b7ae7bd62f304f7c1c3d345").debug().toBlocking().single()
        let account2 = try? api.account.getAccount(byReference: "1.2.34").debug().toBlocking().single()
        XCTAssertEqual(account1?.id, account2?.id)
    }
    
    func testGetAccountByNameNotFound() {
        XCTAssertThrowsError(
            try api.account.getAccount(byName: "xxxxxxxx1234567").debug().toBlocking().single()
        ) { XCTAssertEqual($0.asChainException(), ChainException.network(.notFound)) }
    }
    
    static var allTests = [
        ("testGetAccountByName", testGetAccountByName),
        ("testGetAccountByReference", testGetAccountByReference),
        ("testGetAccountByAddress", testGetAccountByAddress),
        ("testGetAccountIdsByAddress", testGetAccountIdsByAddress),
        ("testGetAccountByIds", testGetAccountByIds),
        ("testGetAccountByNameAndId", testGetAccountByNameAndId),
        ("testGetAccountByNameNotFound", testGetAccountByNameNotFound),
    ]

}
