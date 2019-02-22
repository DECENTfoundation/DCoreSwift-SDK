import Foundation
import BigInt

public struct SubmitContentOperation: Operation {
    
    public let type: OperationType = .contentSubmitOperation
    public var fee: AssetAmount  = .unset
}

extension SubmitContentOperation {
    public func decrypt(_ keyPair: ECKeyPair, address: Address?, nonce: BigInt = CryptoUtils.generateNonce()) throws -> SubmitContentOperation {
        return self
    }
}

extension SubmitContentOperation {
    public func asData() -> Data {
        
        let data = Data.ofZero
        DCore.Logger.debug(crypto: "SubmitContentOperation binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}
