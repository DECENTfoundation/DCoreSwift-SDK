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

extension TransferOperation {
    public func asData() -> Data {
        
        var data = Data()
        data += type.asData()
        data += fee.asData()
        data += from.asData()
        data += to.asFullData()
        data += amount.asData()
        data += memo.asOptionalData()
        data += Data.ofZero
        
        Logger.debug(crypto: "TransferOperation binary: %{private}s", args: { "\(data.toHex()) (\(data)) \(data.bytes)"})
        return data
    }
}
