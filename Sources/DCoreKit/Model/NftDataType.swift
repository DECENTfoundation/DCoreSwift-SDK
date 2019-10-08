import Foundation

public struct NftDataType: Codable {
    public let type: DataType
    public let unique: Bool
    public let modifiable: ModifiableBy
    public let name: String?

    public enum ModifiableBy: String, Codable, Equatable {
        case
        nobody,
        issuer,
        owner,
        both

        var ordinal: Int {
            switch self {
            case .nobody: return 0
            case .issuer: return 1
            case .owner: return 2
            case .both: return 3
            }
        }
    }

    public enum DataType: String, Codable {
        case
        string,
        integer,
        boolean

        var ordinal: Int {
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
        // TODO: Test and fix this method if necessary
        var data = Data()
        data += unique.asData()
        data += UInt64(modifiable.ordinal)
        data += UInt64(type.ordinal)
        data += name.asOptionalData()
        
        DCore.Logger.debug(crypto: "NftDataType binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)s"
        })
        return data
    }
}
