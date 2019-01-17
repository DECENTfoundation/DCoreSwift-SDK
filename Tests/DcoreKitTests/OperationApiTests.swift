import XCTest
import RxBlocking

@testable import DcoreKit

class OperationApiTests: XCTestCase {

    private var wss = DCore.Sdk.create(forWss: "wss://stagesocket.decentgo.com:8090")
    
    func testTransferOperation() {
        let pk = "5J1HnqK3gajNzDWj9Na6fo3gxtphv6MHLE5YLgRmQv8tC8e3rEd"
        let creds = try? Credentials("1.2.17".chain.chainObject!, wif: pk)
        
        let confirm = try? wss.operation.transfer(creds!, to: "1.2.34", amount: AssetAmount(1000000)).debug().toBlocking().single()
        XCTAssertNotNil(confirm)
    }

    static var allTests = [
        ("testTransferOperation", testTransferOperation),
    ]
}
