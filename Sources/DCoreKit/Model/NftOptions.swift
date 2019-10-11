import Foundation

public struct NftOptions: Codable {
    public var issuer: ChainObject {
        willSet { precondition(issuer.objectType == .accountObject, "not a valid account object id") }
    }
    public let maxSupply: UInt32
    public let fixedMaxSupply: Bool
    public let description: String

    private enum CodingKeys: String, CodingKey {
        case
        issuer,
        maxSupply = "max_supply",
        fixedMaxSupply = "fixed_max_supply",
        description
    }
}

extension NftOptions: DataConvertible {
    public func asData() -> Data {
        // TODO: Test and fix this method if necessary
        var data = Data()
        data += issuer.asData()
        data += maxSupply
        data += fixedMaxSupply.asData()
        data += description.asData()
        
        DCore.Logger.debug(crypto: "NftOptions binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)s"
        })
        return data
    }
}
