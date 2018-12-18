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
}

public struct AuthMap: Codable {
    public let value: Address
    public let weight: UInt16
    
    private enum CodingKeys: String, CodingKey {
        case
        value,
        weight
    }
}

extension Authority: DataSerializable {
    public var serialized: Data {
        fatalError("Bytes.concat(weightThreshold.bytes(),byteArrayOf(0), keyAuths.bytes()")
    }
}

extension AuthMap: DataSerializable {
    public var serialized: Data {
        fatalError("Bytes.concat(value.bytes(),weight.bytes()")
    }
}
