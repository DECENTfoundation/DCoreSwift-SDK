import Foundation

public struct TransferOperation: Operation {
    
    public let from: ChainObject
    public let to: ChainObject
    public let amount: AssetAmount
    public var memo: Memo?
    
    public var fee: AssetAmount = .unset
    public let type: OperationType = .transferTwoOperation
    
    private enum CodingKeys: String, CodingKey {
        case
        from,
        to,
        amount,
        memo,
        fee
    }
}

extension TransferOperation: DataEncodable {
    func asData() -> Data {
        
        var data = Data()
        data += type
        data += fee
        data += from
        data += to.objectTypeId
        data += amount
        data += memo
        data += Data.ofZero
        
        Logger.debug(crypto: "TransferOperation binary: %{private}s", args: { "\(data.toHex()) (\(data))"})
        return data
    }
}
