import Foundation

public struct ChainObject {
    
    public let objectType: ObjectType
    public let instance: UInt64

    public var objectId: String {
        return "\(objectType.space).\(objectType.type).\(instance)"
    }
    
    var objectTypeIdBytes: [UInt8] {
        fatalError("Not Implemented get() = (objectType.space.toLong().shl(56) or objectType.type.toLong().shl(48) or instance).bytes()")
    }
    
    init(usingObjectType type: ObjectType) {
        objectType = type
        instance = 0
    }
    
    fileprivate init(usingObjectId id: String) throws {
        let parts = try id.toChainObjectParts()
        objectType = ObjectType.from(space: Int(parts[0])!, type: Int(parts[1])!)
        instance = UInt64(parts[2])!
    }
    
    public static func parse(usingObjectId id: String) throws -> ChainObject {
        fatalError("Not implemeted")
    }

    public static func isValid(usingObjectId id: String) -> Bool {
        return false
    }
}

extension ChainObject: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return objectId
    }
    
    public var debugDescription: String {
        return description
    }
}


extension ChainObject: ByteSerializable {
    public var bytes: [UInt8] {
        fatalError("Not Implemented get() = Varint.writeUnsignedVarLong(instance)")
    }
}

extension ChainObject: Equatable {
    public static func ==(lhs: ChainObject, rhs: ChainObject) -> Bool {
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
        try self.init(usingObjectId: id)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(objectId)
    }
}

extension String {
    public func toChainObject() -> ChainObject {
        return try! ChainObject.parse(usingObjectId: self)
    }
    
    fileprivate func toChainObjectParts() throws -> [String] {
        let regex = try NSRegularExpression(pattern: "(\\d+)\\.(\\d+)\\.(\\d+)(?:\\.(\\d+))?")
        return regex.matches(in: self, range: NSRange(self.startIndex..., in: self)).map {
            String(self[Range($0.range, in: self)!])
        }
    }
}
