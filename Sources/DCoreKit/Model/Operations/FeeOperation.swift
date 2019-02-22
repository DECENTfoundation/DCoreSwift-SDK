import Foundation
import BigInt

struct FeeOperation: Operation {
    
    var fee: AssetAmount = .unset
    var type: OperationType = .unknown
 
    init(_ type: OperationType) {
        self.type = type
    }

    private enum CodingKeys: String, CodingKey {
        case
        fee
    }
}

extension FeeOperation {
    public func decrypt(_ keyPair: ECKeyPair, address: Address?, nonce: BigInt = CryptoUtils.generateNonce()) throws -> FeeOperation {
        return self
    }
}
