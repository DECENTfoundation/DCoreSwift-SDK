import Foundation

public struct Authority: Codable {
    
    public let weightThreshold: Int
    public let accountAuths: AnyValue?
    public let keyAuths: [AuthMap]
    
    private enum CodingKeys: String, CodingKey {
        case
        weightThreshold = "weight_threshold",
        accountAuths = "account_auths",
        keyAuths = "key_auths"
    }
    
    init(from address: Address) {
        self.weightThreshold = 1
        self.accountAuths = .array([])
        self.keyAuths = [AuthMap(value: address)]
    }
}

public struct AuthMap: Codable {
    public let value: Address
    public let weight: UInt16
    
    private enum CodingKeys: String, CodingKey {
        case
        value,
        weight
    }
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        
        self.value = try container.decode(Address.self)
        self.weight = try container.decode(UInt16.self)
    }
    
    init(value: Address, weight: UInt16 = 1) {
        self.value = value
        self.weight = weight
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        
        try container.encode(value)
        try container.encode(weight)
    }
}

extension Authority: DataConvertible {
    public func asData() -> Data {
        var data = Data()
        data += weightThreshold
        data += Data.ofZero
        data += keyAuths.asData()
                
        DCore.Logger.debug(crypto: "Authority binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}

extension AuthMap: DataConvertible {
    public func asData() -> Data {
        var data = Data()
        data += value.asData()
        data += weight.littleEndian
        
        DCore.Logger.debug(crypto: "AuthMap binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}
