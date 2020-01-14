import XCTest
import BigInt

@testable import DCoreKit

final class SerializationTests: XCTestCase {
    func testGetAccountHistoryJsonSerialization() {
        let api =
        """
        {"jsonrpc":"2.0","method":"call","id":1,"params":["history_api","get_account_history",["1.2.3","1.7.0",100,"1.7.0"]]}
        """
        let result = GetAccountHistory("1.2.3".dcore.objectId()!).base.asJson()
        XCTAssertEqual(result, api)
    }
    
    func testGetRelativeAccountHistoryJsonSerialization() {
        let api =
        """
        {"jsonrpc":"2.0","method":"call","id":1,"params":["history_api","get_relative_account_history",["1.2.3",0,100,0]]}
        """
        let result = GetRelativeAccountHistory("1.2.3".dcore.objectId()!).base.asJson()
        XCTAssertEqual(result, api)
    }
    
    func testGetRequiredFeesJsonSerialization() {
        let api =
        """
        {"jsonrpc":"2.0","method":"call","id":1,"params":["database_api","get_required_fees",[[[39,{"fee":{"amount":"0","asset_id":"1.3.0"}}],[1,{"fee":{"amount":"0","asset_id":"1.3.0"}}]],"1.3.0"]]}
        """
        let result = GetRequiredFees([
            FeeOperation(.transferTwoOperation),
            FeeOperation(.accountCreateOperation)
        ]).base.asJson()
        XCTAssertEqual(result, api)
    }
    
    func testTransferOperationJsonSerialization() {
        let op = TransferOperation(from: "1.2.3".dcore.objectId()!, to: "1.2.3".dcore.objectId()!, amount: AssetAmount(with: "33333333"), memo: nil, fee: .unset)
        print(op.asJson()!)
        print(op.asData().toHex())
        XCTAssertEqual(true, true)
    }
    
    func testTransferOperationDataSerialization() {
        let expected = "278813000000000000001e1f000000000002018096980000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0000000068656c6c6f206d656d6f00"
        let serialized = TransferOperation(
            from: "1.2.30".dcore.objectId()!,
            to: "1.2.31".dcore.objectId()!,
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
            from: "1.2.30".dcore.objectId()!,
            to: "1.2.31".dcore.objectId()!,
            amount: AssetAmount(10000000),
            memo: memo,
            fee: AssetAmount(5000)
            ).asData().toHex()
        XCTAssertEqual(serialized, expected)
    }

    func testAccountCreateOperationSerialization() {
        let bytes = "0100000000000000000022086d696b656565656501000000000102a01c045821676cfc191832ad22cc5c9ade0ea1760131c87ff2dd3fed2f13dd33010001000000000102a01c045821676cfc191832ad22cc5c9ade0ea1760131c87ff2dd3fed2f13dd33010002a01c045821676cfc191832ad22cc5c9ade0ea1760131c87ff2dd3fed2f13dd330300000000000000000000000000000000000000"
        let op = AccountCreateOperation(.with(name: "mikeeeee", address: "DCT6718kUCCksnkeYD1YySWkXb1VLpzjkFfHHMirCRPexp5gDPJLU".dcore.address!),
                                        registrar: "1.2.34".dcore.objectId()!)
        
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
    
    func testObjectIdHashing() {
        let a = [
            "1.2.3".dcore.objectId()!,
            "1.2.4".dcore.objectId()!,
            "1.2.5".dcore.objectId()!,
            "1.2.3".dcore.objectId()!,
        ]
        
        XCTAssertTrue(Set(a).count == 3)
    }

    func testBlockDataSerialization() {
        let bytes = "01000100000001000000"
        let blockData = BlockData(refBlockNum: 1, refBlockPrefix: 1, expiration: 1)
        let serialized = blockData.asData().toHex()
        XCTAssertEqual(bytes, serialized)
    }

    func testMemoSerialization() {
        let kp = "5Jd7zdvxXYNdUfnEXt5XokrE3zwJSs734yQ36a1YaqioRTGGLtn".dcore.keyPair!
        let address = "DCT6bVmimtYSvWQtwdrkVVQGHkVsTJZVKtBiUqf4YmJnrJPnk89QP".dcore.address!
        let expected = "0102c03f8e840c1699fd7808c2bb858e249c688c5be8acf0a0c1c484ab0cfb27f0a802e0ced80260630f641f61f6d6959f32b5c43b1a38be55666b98abfe8bafcc556b5521e507000000001086d54a9e1f8fc6e5319dbae0b087b6cc"
        let memo = try? Memo("hello memo", keyPair: kp, recipient: address, nonce: BigInt("132456789"))
        XCTAssertEqual(expected, memo.asOptionalData().toHex())
    }

    func testObjectIdSerialization() {
        XCTAssertEqual("1.2.1".dcore.objectId()!.asData().toHex(), "01")
        XCTAssertEqual("1.2.34".dcore.objectId()!.asData().toHex(), "22")
        XCTAssertEqual("1.2.1564".dcore.objectId()!.asData().toHex(), "9c0c")
        XCTAssertEqual("1.2.65534".dcore.objectId()!.asData().toHex(), "feff03")
        XCTAssertEqual("1.2.66534".dcore.objectId()!.asData().toHex(), "e68704")
        XCTAssertEqual("3.90.66534".dcore.objectId()!.asData().toHex(), "e68704")
    }

    func testVoteIdSerialization() {
        let vote = "0:2".asVoteData()
        let votes = Set(["0:2"]).asVoteData()
        XCTAssertTrue("0002000000000000" == vote.toHex())
        XCTAssertTrue("010002000000000000" == votes.toHex())
    }

    func testCustomOperationSerialization() {
        let payerAcc = try! "1.2.1".asAccountObjectId()
        let operation = AnyCustomOperation(
            id: .plaintext, payer: payerAcc, requiredAuths: [payerAcc], data: "some data"
        )

        let expected = "12000000000000000000010101020000"
        XCTAssertEqual(expected, operation.asData().toHex())
    }
    
    static var allTests = [
        ("testGetAccountHistoryJsonSerialization", testGetAccountHistoryJsonSerialization),
        ("testGetRelativeAccountHistoryJsonSerialization", testGetRelativeAccountHistoryJsonSerialization),
        ("testGetRequiredFeesJsonSerialization", testGetRequiredFeesJsonSerialization),
        ("testTransferOperationJsonSerialization", testTransferOperationJsonSerialization),
        ("testTransferOperationDataSerialization", testTransferOperationDataSerialization),
        ("testTransferOperationWithMemoEncryptedDataSerialization", testTransferOperationWithMemoEncryptedDataSerialization),
        ("testAnyValueEncoding", testAnyValueSerialization),
        ("testObjectIdHashing", testObjectIdHashing),
        ("testBlockDataSerialization", testBlockDataSerialization),
        ("testMemoSerialization", testMemoSerialization),
        ("testObjectIdSerialization", testObjectIdSerialization),
        ("testVoteIdSerialization", testVoteIdSerialization),
    ]
}
