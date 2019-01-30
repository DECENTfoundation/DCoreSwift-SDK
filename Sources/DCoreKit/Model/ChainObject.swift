import Foundation

public struct ChainObject {
    
    public let objectType: ObjectType
    public let instance: UInt64

    public var objectId: String {
        return "\(objectType.space).\(objectType.type).\(instance)"
    }
    
    public init(from type: ObjectType) {
        objectType = type
        instance = 0
    }
    
    public init(from id: String) throws {
        let result = id.matches(regex: "(\\d+)\\.(\\d+)\\.(\\d+)(?:\\.(\\d+))?")
        guard !result.isEmpty else { throw DCoreException.unexpected("Chain object \(id) has invalid format") }
        
        let parts = id.components(separatedBy: ".")
        
        objectType = ObjectType(fromSpace: Int(parts[0]).or(0), type: Int(parts[1]).or(0))
        instance = UInt64(parts[2]).or(0)
    }
}

extension ChainObject: CustomStringConvertible {
    public var description: String {
        return objectId
    }
}

extension ChainObject: DataConvertible {
    public func asFullData() -> Data {
        var bytes = Data()
        bytes += UInt64((UInt64(objectType.space) << 56) | UInt64(objectType.type) << 48 | instance).littleEndian
        return bytes
    }
    
    public func asData() -> Data {
        let data = VarInt(instance).asData()
        
        DCore.Logger.debug(crypto: "ChainObject binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}

extension ChainObject: Equatable {
    public static func == (lhs: ChainObject, rhs: ChainObject) -> Bool {
        return lhs.objectId == rhs.objectId
    }
}

extension ChainObject: Comparable {
    public static func < (lhs: ChainObject, rhs: ChainObject) -> Bool {
        return lhs.objectType < rhs.objectType || (lhs.objectType == rhs.objectType && lhs.instance < rhs.instance)
    }
    
    public static func <= (lhs: ChainObject, rhs: ChainObject) -> Bool {
        return lhs == rhs || lhs < rhs
    }
    
    public static func >= (lhs: ChainObject, rhs: ChainObject) -> Bool {
        return lhs == rhs || lhs > rhs
    }
    
    public static func > (lhs: ChainObject, rhs: ChainObject) -> Bool {
        return lhs.objectType > rhs.objectType || (lhs.objectType == rhs.objectType && lhs.instance > rhs.instance)
    }
}

extension ChainObject: Hashable {
    public func hash(into hasher: inout Hasher) {
        (31 * objectType.hashValue + instance.hashValue).hash(into: &hasher)
    }
}

extension ChainObject: Codable {
    public init(from decoder: Decoder) throws {
        let id = try decoder.singleValueContainer().decode(String.self)
        try self.init(from: id)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(objectId)
    }
}

extension DCoreExtension where Base == String {
    public var chainObject: ChainObject? {
        return try? ChainObject(from: self.base)
    }
}
