import Foundation

public struct NftOptions: Equatable, Codable {
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

    func updated(
        byMaxSupply maxSupply: UInt32? = nil, fixedMaxSupply: Bool? = nil, description: String? = nil) -> NftOptions {
        let newOptions = NftOptions(
            issuer: issuer,
            maxSupply: maxSupply ?? self.maxSupply,
            fixedMaxSupply: fixedMaxSupply ?? self.fixedMaxSupply,
            description: description ?? self.description
        )
        precondition((maxSupply ?? 0) >= self.maxSupply, "Max supply must be at least \(self.maxSupply)")
        precondition(fixedMaxSupply == self.fixedMaxSupply || !self.fixedMaxSupply, "Max supply must remain fixed")
        precondition(maxSupply == self.maxSupply || !self.fixedMaxSupply, "Can not change max supply (it's fixed)")
        precondition(self != newOptions, "no new values to update")
        return newOptions
    }
}

extension NftOptions: DataConvertible {
    public func asData() -> Data {
        var data = Data()
        data += issuer.asData()
        data += maxSupply.littleEndian
        data += fixedMaxSupply.asData()
        data += description.asData()
        
        DCore.Logger.debug(crypto: "NftOptions binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)s"
        })
        return data
    }
}
