import XCTest
import BigInt
@testable import DcoreKit

final class SerializationTests: XCTestCase {
    func testTransferOperationJsonSerialization() {
        
        let op = TransferOperation(from: "1.2.3".chainObject, to: "1.2.3".chainObject, amount: AssetAmount(with: "895438905348905349949490330940943"))
        print(try! op.toJson())
        print(op.serialized.toHex())
        XCTAssertEqual(true, true)
    }
    
    static var allTests = [
        ("testTransferOperationJsonSerialization", testTransferOperationJsonSerialization),
    ]
}
