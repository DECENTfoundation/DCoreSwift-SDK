import Foundation

public struct Address: Codable {
    
    public let publicKey: String
    public var prefix: String = PREFIX
    
    
    public func encode() -> String {
        fatalError("Not implemented")
    }
    
    public static func decode(from address: String) throws -> Address {
        fatalError("Not implemented")
    }
    
    public static func isValid(using address: String) -> Bool {
        return false
    }
    
    private static let PREFIX: String = "DCT"
}

extension Address: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return encode()
    }
    
    public var debugDescription: String {
        return description
    }
}

extension Address: ByteSerializable {
    public var bytes: [UInt8] {
        fatalError("Not implemented")
    }
}

extension String {
    public var address: Address? {
        return try? Address.decode(from: self)
    }
}
