import XCTest
import BigInt
@testable import DcoreKit

final class SerializationTests: XCTestCase {
    func testGetAccountHistoryJsonSerialization() {
        let api =
        """
        {"jsonrpc":"2.0","method":"call","id":1,"params":[3,"get_account_history",["1.2.3","1.7.0",100,"1.7.0"]]}
        """
        let result = try? GetAccountHistory(accountId: "1.2.3".chainObject).toJson()
        XCTAssertEqual(result, api)
    }
    
    func testGetRelativeAccountHistoryJsonSerialization() {
        let api =
        """
        {"jsonrpc":"2.0","method":"call","id":1,"params":[3,"get_relative_account_history",["1.2.3",0,100,0]]}
        """
        let result = try? GetRelativeAccountHistory(accountId: "1.2.3".chainObject).toJson()
        XCTAssertEqual(result, api)
    }
    
    func testGetRequiredFeesJsonSerialization() {
        let api =
        """
        {"jsonrpc":"2.0","method":"call","id":1,"params":[0,"get_required_fees",[[[39,{"type":39,"fee":{"amount":"0","asset_id":"1.3.0"}}],[1,{"type":1,"fee":{"amount":"0","asset_id":"1.3.0"}}]],"1.3.0"]]}
        """
        let result = try? GetRequiredFees(operations: [
            EmptyOperation(type: OperationType.TRANSFER2_OPERATION),
            EmptyOperation(type: OperationType.ACCOUNT_CREATE_OPERATION)
        ]).toJson()
        
        XCTAssertEqual(result, api)
    }
    
    func testTransferOperationJsonSerialization() {
        
        let op = TransferOperation(from: "1.2.3".chainObject, to: "1.2.3".chainObject, amount: AssetAmount(with: "895438905348905349949490330940943"))
        print(try! op.toJson())
        print(op.serialized.toHex())
        XCTAssertEqual(true, true)
    }
    
    func testTransferOperationDataSerialization() {
        
        let serialized = "278813000000000000001e1f000000000002018096980000000000000102c03f8e840c1699fd7808c2bb858e249c688c5be8acf0a0c1c484ab0cfb27f0a802e0ced80260630f641f61f6d6959f32b5c43b1a38be55666b98abfe8bafcc556b5521e507000000001086d54a9e1f8fc6e5319dbae0b087b6cc00"
        
        let kp = "5Jd7zdvxXYNdUfnEXt5XokrE3zwJSs734yQ36a1YaqioRTGGLtn".keyPair!
        let recipient = "DCT6bVmimtYSvWQtwdrkVVQGHkVsTJZVKtBiUqf4YmJnrJPnk89QP".address!
        let memo = Memo("hello memo", keyPair: kp, recipient: recipient, nonce: BigInt(132456789))
        let op = TransferOperation(from: "1.2.30".chainObject, to: "1.2.31".chainObject, amount: AssetAmount(10000000), memo: memo, fee: AssetAmount(5000))
        
        XCTAssertEqual(op.serialized.toHex(), serialized)
    }
    
    static var allTests = [
        ("testGetAccountHistoryJsonSerialization", testGetAccountHistoryJsonSerialization),
        ("testGetRelativeAccountHistoryJsonSerialization", testGetRelativeAccountHistoryJsonSerialization),
        ("testGetRequiredFeesJsonSerialization", testGetRequiredFeesJsonSerialization),
        ("testTransferOperationJsonSerialization", testTransferOperationJsonSerialization),
        ("testTransferOperationDataSerialization", testTransferOperationDataSerialization),
    ]
}
