import XCTest
import RxBlocking

@testable import DCoreKit

final class BalanceApiTests: XCTestCase {

    private let rest = DCore.Sdk.create(forRest: DCore.TestConstant.httpUrl)
    
    func testGetBalanceByAccountId() {
   
        let balance = try? rest.balance.getWithAsset(byAccountId: "1.2.28").debug().toBlocking().single()
        XCTAssertEqual(balance?.asset.id, DCore.Constant.dct)
        XCTAssertEqual(balance?.amount.assetId, DCore.Constant.dct)
    }
    
    func testGetBalanceByAccountIdAndAssetId() {
        
        let balance = try? rest.balance.get(byAccountId: "1.2.28", asset: DCore.Constant.dct).debug().toBlocking().single()
        XCTAssertEqual(balance?.assetId, DCore.Constant.dct)
    }

    func testGetAllBalancesWithAsset() {
        
        let balances = try? rest.balance.getAllWithAsset(byAccountId: "1.2.28").debug().toBlocking().single()
        XCTAssertEqual(balances?.first?.first.id, DCore.Constant.dct)
    }
    
    static var allTests = [
        ("testGetBalanceByAccountId", testGetBalanceByAccountId),
        ("testGetBalanceByAccountIdAndAssetId", testGetBalanceByAccountIdAndAssetId),
    ]
}
