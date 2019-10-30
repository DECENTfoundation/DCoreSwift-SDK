import Foundation
import BigInt

public struct NftUpdateOperation: Operation {
    
    public var issuer: ChainObject {
        willSet { precondition(issuer.objectType == .accountObject, "not a valid account object id") }
    }
    public var nftId: ChainObject {
        willSet { precondition(nftId.objectType == .nftObject, "not a valid nft object id") }
    }
    public var options: NftOptions {
        willSet {
            precondition(
                options.description.count <= DCore.Constant.uiaDescriptionMaxChars,
                "description cannot be longer than \(DCore.Constant.uiaDescriptionMaxChars) chars"
            )
            precondition(options.maxSupply <= 0xFFFFFFFF)
        }
    }
    
    public let type: OperationType = .nftUpdateDefinition
    public var fee: AssetAmount  = .unset
    
    private enum CodingKeys: String, CodingKey {
        case
        issuer = "current_issuer",
        nftId = "nft_id",
        options,
        fee
    }
}

extension NftUpdateOperation {
    public func decrypt(_ keyPair: ECKeyPair, address: Address? = nil, nonce: BigInt = CryptoUtils.generateNonce()) throws -> NftUpdateOperation {
        return self
    }
}

extension NftUpdateOperation {
    public func asData() -> Data {
        var data = Data()
        data += type.asData()
        data += fee.asData()
        data += issuer.asData()
        data += nftId.asData()
        data += options.asData()
        data += Data.ofZero
        
        DCore.Logger.debug(crypto: "NftUpdateOperation binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}
