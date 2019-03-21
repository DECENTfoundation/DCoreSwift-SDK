import Foundation
import BigInt

extension BigInt {
    fileprivate static let generator: BigInt = 3
    fileprivate static let modulus: BigInt = BigInt(
        """
        11760620558671662461946567396662025495126946227619472274601251081547302009186313
        201119191293557856181195016058359990840577430081932807832465057884143546419
        """
    )
}

public struct ElGamalKeyPair {

    let privateKey: BigInt
    public let publicKey: PubKey
    
    public init(_ keyPair: ECKeyPair) {
        let data = CryptoUtils.hash512(keyPair.privateKey.data)
        self.init(BigInt(sign: .plus, magnitude: BigUInt(data)))
    }
    
    init(_ privateKey: BigInt) {
        self.privateKey = privateKey
        self.publicKey = PubKey(
            (.generator as BigInt).power(privateKey, modulus: .modulus)
        )
    }
}
