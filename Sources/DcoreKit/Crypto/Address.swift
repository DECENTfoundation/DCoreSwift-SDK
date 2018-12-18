import Foundation

public struct Address {
    let prefix: String
    let publicKey: PublicKey
    
    
    init(fromPublicKey data: Data, prefix: String = "DCT") {
        self.prefix = prefix
        self.publicKey = PublicKey(data: data)
    }
    
    init(fromKeyPair pair: ECKeyPair) {
        self.init(fromPublicKey: pair.publicKey.data)
    }
    
    init(from value: String) throws {
 
        guard let prefix = value[safe: 0...3], let suffix = value[safe: 3...value.count], let decoded = Base58.decode(suffix) else {
            throw CryptoError.invalidFormat
        }
        
        let key = decoded.prefix(decoded.count - 4)
        
        let h = CryptoUtils.sha256sha256(key)
        let calculatedChecksum = h.prefix(4)
        let originalChecksum = decoded.suffix(4)
        
        guard calculatedChecksum == originalChecksum else {
            throw CryptoError.invalidChecksum
        }
        
        self.init(fromPublicKey: key, prefix: prefix)
    }
}

extension Address: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        try self.init(from: try container.decode(String.self))
    }
    
    public func encode(to encoder: Encoder) throws {
        fatalError("Not Implemented")
    }
}

extension Address: DataSerializable {
    public var serialized: Data {
        return publicKey.data
    }
}

extension String {
    public var address: Address? {
        return try? Address(from: self)
    }
}
