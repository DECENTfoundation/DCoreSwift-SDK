import Foundation
import BigInt

public struct NftCreateOperation: Operation {

    public var symbol: String {
        willSet { precondition(Asset.hasValid(symbol: symbol), "invalid nft symbol: \(symbol)") }
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
    public var definitions: [NftDataType] {
        willSet {
            precondition(
                definitions.allSatisfy { $0.modifiable == NftDataType.ModifiableBy.nobody || !$0.name.isNil() },
                "modifiable data type must have name"
            )
            precondition(
                definitions.allSatisfy { $0.name.isNil() || ($0.name?.count ?? 0) <= DCore.Constant.nftNameMaxChars },
                "name cannot be longer then \(DCore.Constant.nftNameMaxChars) chars"
            )
        }
    }
    public var transferable: Bool
    
    public let type: OperationType = .nftCreateDefinition
    public var fee: AssetAmount  = .unset
    
    private enum CodingKeys: String, CodingKey {
        case
        symbol,
        options,
        definitions,
        transferable,
        fee
    }
}

extension NftCreateOperation {
    public func decrypt(_ keyPair: ECKeyPair, address: Address? = nil, nonce: BigInt = CryptoUtils.generateNonce()) throws -> NftCreateOperation {
        return self
    }
}

extension NftCreateOperation {
    public func asData() -> Data {
        var data = Data()
        data += type.asData()
        data += fee.asData()
        data += symbol.asData()
        data += options.asData()
        data += definitions.asData()
        data += transferable.asData()
        data += Data.ofZero
        
        DCore.Logger.debug(crypto: "NftCreateOperation binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}
