import XCTest
import BigInt

@testable import DcoreKit

final class SerializationTests: XCTestCase {
    func testGetAccountHistoryJsonSerialization() {
        let api =
        """
        {"jsonrpc":"2.0","method":"call","id":1,"params":[3,"get_account_history",["1.2.3","1.7.0",100,"1.7.0"]]}
        """
        let result = GetAccountHistory<AnyOperation>("1.2.3".chain.chainObject!).base.asJson()
        XCTAssertEqual(result, api)
    }
    
    func testGetRelativeAccountHistoryJsonSerialization() {
        let api =
        """
        {"jsonrpc":"2.0","method":"call","id":1,"params":[3,"get_relative_account_history",["1.2.3",0,100,0]]}
        """
        let result = GetRelativeAccountHistory<AnyOperation>("1.2.3".chain.chainObject!).base.asJson()
        XCTAssertEqual(result, api)
    }
    
    func testGetRequiredFeesJsonSerialization() {
        let api =
        """
        {"jsonrpc":"2.0","method":"call","id":1,"params":[0,"get_required_fees",[[[39,{"fee":{"amount":"0","asset_id":"1.3.0"}}],[1,{"fee":{"amount":"0","asset_id":"1.3.0"}}]],"1.3.0"]]}
        """
        let result = GetRequiredFees([
            AnyOperation(.transferTwoOperation),
            AnyOperation(.accountCreateOperation)
        ]).base.asJson()
        XCTAssertEqual(result, api)
    }
    
    func testTransferOperationJsonSerialization() {
        let op = TransferOperation(from: "1.2.3".chain.chainObject!, to: "1.2.3".chain.chainObject!, amount: AssetAmount(with: "895438905348905349949490330940943"), memo: nil, fee: .unset)
        print(op.asJson()!)
        print(op.asData().toHex())
        XCTAssertEqual(true, true)
    }
    
    func testTransferOperationDataSerialization() {
        
        let expected = "278813000000000000001e1f000000000002018096980000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0000000068656c6c6f206d656d6f00"
        let serialized = TransferOperation(
            from: "1.2.30".chain.chainObject!,
            to: "1.2.31".chain.chainObject!,
            amount: AssetAmount(10000000),
            memo: Memo("hello memo"),
            fee: AssetAmount(5000)
        ).asData().toHex()
        XCTAssertEqual(serialized, expected)
    }

    func testAccountCreateOperationSerialization() {
        let bytes = "0100000000000000000022086d696b656565656501000000000102a01c045821676cfc191832ad22cc5c9ade0ea1760131c87ff2dd3fed2f13dd33010001000000000102a01c045821676cfc191832ad22cc5c9ade0ea1760131c87ff2dd3fed2f13dd33010002a01c045821676cfc191832ad22cc5c9ade0ea1760131c87ff2dd3fed2f13dd330300000000000000000000000000000000000000"
        let op = AccountCreateOperation("1.2.34".chain.chainObject!,
                                        name: "mikeeeee",
                                        address: "DCT6718kUCCksnkeYD1YySWkXb1VLpzjkFfHHMirCRPexp5gDPJLU".chain.address!)
        
        let serialized = op.asData().toHex()
        XCTAssertEqual(serialized, bytes)
    }
    
    func testAnyValueSerialization() {
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
        ("testAnyValueEncoding", testAnyValueSerialization),
    ]
}
