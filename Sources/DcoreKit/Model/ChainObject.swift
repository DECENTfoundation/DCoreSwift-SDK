import Foundation

public struct ChainObject {
    public let objectType: ObjectType
    public let instance: UInt64

    public var objectId: String {
        return "\(objectType.space).\(objectType.type).\(instance)"
    }
    
    public var objectTypeId: Data {
        return Data(bytes: [objectType.space << 56 | objectType.type << 48 | UInt8.with(value: instance)])
    }
    
    public init(from type: ObjectType) {
        objectType = type
        instance = 0
    }
    
    public init(from id: String) throws {
        let result = id.matches(regex: "(\\d+)\\.(\\d+)\\.(\\d+)(?:\\.(\\d+))?")
        guard !result.isEmpty else { throw DCoreError.illegal("chain boject invalid format") }
        
        let parts = id.components(separatedBy: ".")
        
        objectType = ObjectType(fromSpace: Int(parts[0])!, type: Int(parts[1])!)
        instance = UInt64(parts[2])!
    }
}

extension ChainObject: CustomStringConvertible {
    public var description: String {
        return objectId
    }
}

extension ChainObject: DataSerializable {
    public var serialized: Data {
        return VarInt(integerLiteral: instance).serialized
    }
}

extension ChainObject: Equatable {
    public static func == (lhs: ChainObject, rhs: ChainObject) -> Bool {
        return lhs.objectId == rhs.objectId
    }
}

extension ChainObject: Hashable {
    public var hashValue: Int {
        return 31 * objectType.hashValue + instance.hashValue
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

extension String {
    public var chainObject: ChainObject {
        guard let obj = try? ChainObject(from: self) else { fatalError("chain boject invalid format") }
        return obj
    }
}
