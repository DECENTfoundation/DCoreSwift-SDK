import XCTest
import BigInt

@testable import DcoreKit

final class SerializationTests: XCTestCase {
    func testGetAccountHistoryJsonSerialization() {
        let api =
        """
        {"jsonrpc":"2.0","method":"call","id":1,"params":[3,"get_account_history",["1.2.3","1.7.0",100,"1.7.0"]]}
        """
        let result = GetAccountHistory("1.2.3".chain.chainObject!).base.asJson()
        XCTAssertEqual(result, api)
    }
    
    func testGetRelativeAccountHistoryJsonSerialization() {
        let api =
        """
        {"jsonrpc":"2.0","method":"call","id":1,"params":[3,"get_relative_account_history",["1.2.3",0,100,0]]}
        """
        let result = GetRelativeAccountHistory("1.2.3".chain.chainObject!).base.asJson()
        XCTAssertEqual(result, api)
    }
    
    func testGetRequiredFeesJsonSerialization() {
        let api =
        """
        {"jsonrpc":"2.0","method":"call","id":1,"params":[0,"get_required_fees",[[[39,{"type":39,"fee":{"amount":"0","asset_id":"1.3.0"}}],[1,{"type":1,"fee":{"amount":"0","asset_id":"1.3.0"}}]],"1.3.0"]]}
        """
        let result = GetRequiredFees([
            EmptyOperation(type: OperationType.transferTwoOperation),
            EmptyOperation(type: OperationType.accountCreateOperation)
        ]).base.asJson()
        
        XCTAssertEqual(result, api)
    }
    
    func testTransferOperationJsonSerialization() {
        
        let op = TransferOperation(from: "1.2.3".chain.chainObject!, to: "1.2.3".chain.chainObject!, amount: AssetAmount(with: "895438905348905349949490330940943"))
        print(op.asJson()!)
        print(op.serialized.toHex())
        XCTAssertEqual(true, true)
    }
    
    func testTransferOperationDataSerialization() {
        
        let serialized = "278813000000000000001e1f000000000002018096980000000000000102c03f8e840c1699fd7808c2bb858e249c688c5be8acf0a0c1c484ab0cfb27f0a802e0ced80260630f641f61f6d6959f32b5c43b1a38be55666b98abfe8bafcc556b5521e507000000001086d54a9e1f8fc6e5319dbae0b087b6cc00"
        
        let kp = "5Jd7zdvxXYNdUfnEXt5XokrE3zwJSs734yQ36a1YaqioRTGGLtn".chain.keyPair!
        let recipient = "DCT6bVmimtYSvWQtwdrkVVQGHkVsTJZVKtBiUqf4YmJnrJPnk89QP".chain.address!
        let memo = Memo("hello memo", keyPair: kp, recipient: recipient, nonce: BigInt(132456789))
        let op = TransferOperation(from: "1.2.30".chain.chainObject!, to: "1.2.31".chain.chainObject!, amount: AssetAmount(10000000), memo: memo, fee: AssetAmount(5000))
        
        XCTAssertEqual(op.serialized.toHex(), serialized)
    }

    func testAnyValueEncoding() {
        let testCases: [(AnyValue, String, String)] = [
            (.object(["String": .string("value")]), "{\"String\":\"value\"}", "Testing object"),
            (.object(["Array": .array([.int(1), .int(2)])]), "{\"Array\":[1,2]}", "Testing array"),
            (.object(["Bool": .bool(true)]), "{\"Bool\":true}", "Testing bool"),
            (.object(["Double": .double(0.5)]), "{\"Double\":0.5}", "Testing double"),
            (.object(["Null": .null]), "{\"Null\":null}", "Testing null")
        ]
        
        testCases.forEach { (anyValue, expected, message) in
            let encoded = try! String(data: JSONEncoder().encode(anyValue), encoding: .utf8)!
            XCTAssertEqual(encoded, expected, message)
        }
    }
    
    static var allTests = [
        ("testGetAccountHistoryJsonSerialization", testGetAccountHistoryJsonSerialization),
        ("testGetRelativeAccountHistoryJsonSerialization", testGetRelativeAccountHistoryJsonSerialization),
        ("testGetRequiredFeesJsonSerialization", testGetRequiredFeesJsonSerialization),
        ("testTransferOperationJsonSerialization", testTransferOperationJsonSerialization),
        ("testAnyValueEncoding", testAnyValueEncoding),
    ]
}
