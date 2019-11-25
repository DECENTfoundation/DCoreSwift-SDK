import Foundation
import BigInt

public struct CancelContentOperation: Operation {
    
    public let author: AccountObjectId
    public let uri: String
    public let type: OperationType = .contentCancellationOperation
    public var fee: AssetAmount  = .unset
    
    private enum CodingKeys: String, CodingKey {
        case
        author,
        uri = "URI",
        fee
    }
}

extension CancelContentOperation {
    public func decrypt(_ keyPair: ECKeyPair, address: Address? = nil, nonce: BigInt = CryptoUtils.generateNonce()) throws -> CancelContentOperation {
        return self
    }
}

extension CancelContentOperation {
    public func asData() -> Data {
        
        var data = Data()
        data += type.asData()
        data += fee.asData()
        data += author.asData()
        data += uri.asData()
        
        DCore.Logger.debug(crypto: "CancelContentOperation binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}
