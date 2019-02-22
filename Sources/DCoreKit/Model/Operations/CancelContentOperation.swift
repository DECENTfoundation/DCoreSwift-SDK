import Foundation
import BigInt

public struct CancelContentOperation: Operation {
    
    public let type: OperationType = .contentCancellationOperation
    public var fee: AssetAmount  = .unset
}

extension CancelContentOperation {
    public func decrypt(_ keyPair: ECKeyPair, address: Address? = nil, nonce: BigInt = CryptoUtils.generateNonce()) throws -> CancelContentOperation {
        return self
    }
}

extension CancelContentOperation {
    public func asData() -> Data {
        
        let data = Data.ofZero
        DCore.Logger.debug(crypto: "CancelContentOperation binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}
