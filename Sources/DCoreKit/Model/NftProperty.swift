import Foundation

/**
 Property wrapper for properties of structs conforming to NftModel protocol
 Used to generate NftDataType from marked properties (is property of a NFT modifiable and unique)
 */
@propertyWrapper
public struct NftProperty<T: Codable>: Codable {
    public var wrappedValue: T
    let unique: Bool
    let modifiableBy: NftDataType.ModifiableBy

    /**
     Init of NftProperty

     - Parameter wrappedValue: Wrapped property.
     */
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        unique = false
        modifiableBy = .nobody
    }

    /**
     Init of NftProperty

     - Parameter wrappedValue: Wrapped property.
     - Parameter unique: Is this property of NFT unique per token.
     */
    public init(wrappedValue: T, unique: Bool) {
        self.wrappedValue = wrappedValue
        self.unique = unique
        self.modifiableBy = .nobody
    }

    /**
     Init of NftProperty

     - Parameter wrappedValue: Wrapped property.
     - Parameter modifiableBy: Who can modify this property of NFT.
     */
    public init(wrappedValue: T, modifiableBy: NftDataType.ModifiableBy) {
        self.wrappedValue = wrappedValue
        self.unique = false
        self.modifiableBy = modifiableBy
    }

    /**
     Full init of NftProperty

     - Parameter wrappedValue: Wrapped property.
     - Parameter unique: Is this property of NFT unique per token.
     - Parameter modifiableBy: Who can modify this property of NFT.
     */
    public init(wrappedValue: T, unique: Bool, modifiableBy: NftDataType.ModifiableBy) {
        self.wrappedValue = wrappedValue
        self.unique = unique
        self.modifiableBy = modifiableBy
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(wrappedValue: try container.decode(T.self))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
