import Foundation
import BigInt

public struct TransferOperation: Operation {
    
    public let from: ChainObject
    public let to: ChainObject
    public let amount: AssetAmount
    public var memo: Memo?
    
    public var fee: AssetAmount = .unset
    public let type: OperationType = .transferTwoOperation
    var mutableType: OperationType = .transferTwoOperation
    
    private enum CodingKeys: String, CodingKey {
        case
        from,
        to,
        amount,
        memo,
        fee
    }

    init(from: ChainObject,
         to: ChainObject,
         amount: AssetAmount,
         memo: Memo?,
         fee: AssetAmount) {
        self.from = from
        self.to = to
        self.amount = amount
        self.memo = memo
        self.fee = fee
    }
}

extension TransferOperation {
    
    public func decrypt(_ keyPair: ECKeyPair, address: Address? = nil, nonce: BigInt = CryptoUtils.generateNonce()) throws -> TransferOperation {
        var op = self
        op.memo = try memo?.decrypt(keyPair, address: address, nonce: nonce)
        
        return op
    }
    
    public func asData() -> Data {
        
        var data = Data()
        data += mutableType.asData()
        data += fee.asData()
        data += from.asData()
        data += mutableType == .transferTwoOperation ? to.asFullData() : to.asData()
        data += amount.asData()
        data += memo.asOptionalData()
        data += Data.ofZero
        
        DCore.Logger.debug(crypto: "TransferOperation binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}
