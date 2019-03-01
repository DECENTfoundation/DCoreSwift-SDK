import XCTest
import RxBlocking

@testable import DCoreKit

class OperationApiTests: XCTestCase {

    private let wss = DCore.Sdk.create(forWss: "wss://stagesocket.decentgo.com:8090")
    
    override func setUp() {
        super.setUp()
        DCore.Logger.xcode(filterCategories: [.network])
    }
    
    func testTransferOperation() {
        let pk = "5J1HnqK3gajNzDWj9Na6fo3gxtphv6MHLE5YLgRmQv8tC8e3rEd"
        let creds = try? Credentials("1.2.17".dcore.chainObject!, wif: pk)

        let confirm = try? wss.operation.transfer(creds!, to: "1.2.34", amount: AssetAmount(1), message: "Ahoj",
                                                  encrypted: false).debug().toBlocking().single()
        XCTAssertNotNil(confirm)
    }
    
    func testTransferOperationToChainObjectWithOtherVarInt() {
        let pk = "5J1HnqK3gajNzDWj9Na6fo3gxtphv6MHLE5YLgRmQv8tC8e3rEd"
        let creds = try? Credentials("1.2.17".dcore.chainObject!, wif: pk)
        
        let confirm = try? wss.operation.transfer(creds!, to: "1.2.687", amount: AssetAmount(1), message: "Ahoj",
                                                  encrypted: false).debug().toBlocking().single()
        XCTAssertNotNil(confirm)
    }

    static var allTests = [
        ("testTransferOperation", testTransferOperation),
        ("testTransferOperationToChainObjectWithOtherVarInt", testTransferOperationToChainObjectWithOtherVarInt)
    ]
}
