import Foundation

public struct NftDataType: Codable {
    public let type: TypeLiteral
    public let unique: Bool
    public let modifiable: ModifiableBy
    public let name: String?

    public enum ModifiableBy: String, Codable, Equatable {
        case
        nobody,
        issuer,
        owner,
        both

        var ordinal: Int64 {
            switch self {
            case .nobody: return 0
            case .issuer: return 1
            case .owner: return 2
            case .both: return 3
            }
        }
    }

    public enum TypeLiteral: String, Codable {
        case
        string,
        integer,
        boolean

        var ordinal: Int64 {
            switch self {
            case .string: return 0
            case .integer: return 1
            case .boolean: return 2
            }
        }
    }
}

extension NftDataType: DataConvertible {
    public func asData() -> Data {
        var data = Data()
        data += unique.asData()
        data += modifiable.ordinal.littleEndian
        data += type.ordinal.littleEndian
        data += name.asOptionalData()
        
        DCore.Logger.debug(crypto: "NftDataType binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)s"
        })
        return data
    }
}
