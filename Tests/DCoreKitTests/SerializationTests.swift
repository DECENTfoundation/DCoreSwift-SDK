import XCTest
import BigInt

@testable import DCoreKit

final class SerializationTests: XCTestCase {
    func testGetAccountHistoryJsonSerialization() {
        let api =
        """
        {"jsonrpc":"2.0","method":"call","id":1,"params":[3,"get_account_history",["1.2.3","1.7.0",100,"1.7.0"]]}
        """
        let result = GetAccountHistory("1.2.3".dcore.chainObject!).base.asJson()
        XCTAssertEqual(result, api)
    }
    
    func testGetRelativeAccountHistoryJsonSerialization() {
        let api =
        """
        {"jsonrpc":"2.0","method":"call","id":1,"params":[3,"get_relative_account_history",["1.2.3",0,100,0]]}
        """
        let result = GetRelativeAccountHistory("1.2.3".dcore.chainObject!).base.asJson()
        XCTAssertEqual(result, api)
    }
    
    func testGetRequiredFeesJsonSerialization() {
        let api =
        """
        {"jsonrpc":"2.0","method":"call","id":1,"params":[0,"get_required_fees",[[[39,{"fee":{"amount":"0","asset_id":"1.3.0"}}],[1,{"fee":{"amount":"0","asset_id":"1.3.0"}}]],"1.3.0"]]}
        """
        let result = GetRequiredFees([
            FeeOperation(.transferTwoOperation),
            FeeOperation(.accountCreateOperation)
        ]).base.asJson()
        XCTAssertEqual(result, api)
    }
    
    func testTransferOperationJsonSerialization() {
        let op = TransferOperation(from: "1.2.3".dcore.chainObject!, to: "1.2.3".dcore.chainObject!, amount: AssetAmount(with: "33333333"), memo: nil, fee: .unset)
        print(op.asJson()!)
        print(op.asData().toHex())
        XCTAssertEqual(true, true)
    }
    
    func testTransferOperationDataSerialization() {
        let expected = "278813000000000000001e1f000000000002018096980000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0000000068656c6c6f206d656d6f00"
        let serialized = TransferOperation(
            from: "1.2.30".dcore.chainObject!,
            to: "1.2.31".dcore.chainObject!,
            amount: AssetAmount(10000000),
            memo: try? Memo("hello memo", keyPair: nil, recipient: nil),
            fee: AssetAmount(5000)
        ).asData().toHex()
        XCTAssertEqual(serialized, expected)
    }
    
    func testTransferOperationWithMemoEncryptedDataSerialization() {
        let kp = "5Jd7zdvxXYNdUfnEXt5XokrE3zwJSs734yQ36a1YaqioRTGGLtn".dcore.keyPair!
        let address = "DCT6bVmimtYSvWQtwdrkVVQGHkVsTJZVKtBiUqf4YmJnrJPnk89QP".dcore.address!
        let expected = "278813000000000000001e1f000000000002018096980000000000000102c03f8e840c1699fd7808c2bb858e249c688c5be8acf0a0c1c484ab0cfb27f0a802e0ced80260630f641f61f6d6959f32b5c43b1a38be55666b98abfe8bafcc556b5521e507000000001086d54a9e1f8fc6e5319dbae0b087b6cc00"
        let memo = try? Memo("hello memo", keyPair: kp, recipient: address, nonce: BigInt("132456789"))
        let serialized = TransferOperation(
            from: "1.2.30".dcore.chainObject!,
            to: "1.2.31".dcore.chainObject!,
            amount: AssetAmount(10000000),
            memo: memo,
            fee: AssetAmount(5000)
            ).asData().toHex()
        XCTAssertEqual(serialized, expected)
    }

    func testAccountCreateOperationSerialization() {
        let bytes = "0100000000000000000022086d696b656565656501000000000102a01c045821676cfc191832ad22cc5c9ade0ea1760131c87ff2dd3fed2f13dd33010001000000000102a01c045821676cfc191832ad22cc5c9ade0ea1760131c87ff2dd3fed2f13dd33010002a01c045821676cfc191832ad22cc5c9ade0ea1760131c87ff2dd3fed2f13dd330300000000000000000000000000000000000000"
        let op = AccountCreateOperation("1.2.34".dcore.chainObject!,
                                        name: "mikeeeee",
                                        address: "DCT6718kUCCksnkeYD1YySWkXb1VLpzjkFfHHMirCRPexp5gDPJLU".dcore.address!)
        
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
    
    func testChainObjectHashing() {
        let a = [
            "1.2.3".dcore.chainObject!,
            "1.2.4".dcore.chainObject!,
            "1.2.5".dcore.chainObject!,
            "1.2.3".dcore.chainObject!,
        ]
        
        XCTAssertTrue(Set(a).count == 3)
    }

    func testBlockDataSerialization() {
        let bytes = "01000100000001000000"
        let blockData = BlockData(refBlockNum: 1, refBlockPrefix: 1, expiration: 1)
        let serialized = blockData.asData().toHex()
        XCTAssertEqual(bytes, serialized)
    }
    
    static var allTests = [
        ("testGetAccountHistoryJsonSerialization", testGetAccountHistoryJsonSerialization),
        ("testGetRelativeAccountHistoryJsonSerialization", testGetRelativeAccountHistoryJsonSerialization),
        ("testGetRequiredFeesJsonSerialization", testGetRequiredFeesJsonSerialization),
        ("testTransferOperationJsonSerialization", testTransferOperationJsonSerialization),
        ("testTransferOperationDataSerialization", testTransferOperationDataSerialization),
        ("testTransferOperationWithMemoEncryptedDataSerialization", testTransferOperationWithMemoEncryptedDataSerialization),
        ("testAnyValueEncoding", testAnyValueSerialization),
        ("testChainObjectHashing", testChainObjectHashing),
        ("testBlockDataSerialization", testBlockDataSerialization),
    ]
}
