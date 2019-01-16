import Foundation

public struct Address {
    
    static let PREFIX = "DCT"
    
    let prefix: String
    let publicKey: PublicKey
    
    init(fromPublicKey data: Data, prefix: String = PREFIX) {
        self.prefix = prefix
        self.publicKey = PublicKey(data: data)
    }
    
    init(fromKeyPair pair: ECKeyPair) {
        self.init(fromPublicKey: pair.publicKey.data)
    }
    
    init(from value: String) throws {
        guard
            let prefix = value[safe: 0..<3],
            let suffix = value[safe: 3..<value.count],
            let decoded = Base58.decode(suffix),
            decoded.count > 3 else {
            throw ChainException.crypto(.failDecode("Address \(value) has invalid format"))
        }
 
        let key = decoded.prefix(decoded.count - 4)
        let calculated = CryptoUtils.ripemd160(key)
        let calculatedChecksum = calculated.prefix(4)
        let originalChecksum = decoded.suffix(4)
     
        guard calculatedChecksum == originalChecksum else {
            throw ChainException.crypto(.failDecode("Address \(value) has invalid checksum"))
        }
        
        self.init(fromPublicKey: key, prefix: prefix)
    }
}

extension Address: Equatable {
    public static func == (lhs: Address, rhs: Address) -> Bool {
        return lhs.publicKey == rhs.publicKey && lhs.prefix == rhs.prefix
    }
}

extension Address: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        let calculated = CryptoUtils.ripemd160(serialized)
        let calculatedChecksum = calculated.prefix(4)
        
        return prefix + Base58.encode(serialized+calculatedChecksum)
    }
    
    public var debugDescription: String {
        return description
    }
}

extension Address: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        try self.init(from: try container.decode(String.self))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}

extension Address: DataSerializable {
    public var serialized: Data {
        return publicKey.data
    }
}

extension Chain where Base == String {
    public var address: Address? {
        return try? Address(from: self.base)
    }
}
