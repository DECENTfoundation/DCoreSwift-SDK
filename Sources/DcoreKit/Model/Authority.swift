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
    
    init(address: Address) {
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
    
    init(value: Address, weight: UInt16 = 1) {
        self.value = value
        self.weight = weight
    }
}

extension Authority: DataSerializable {
    public var serialized: Data {
        var data = Data()
        data += weightThreshold
        data += Data(count: 1)
        data += keyAuths
        return data
    }
}

extension AuthMap: DataSerializable {
    public var serialized: Data {
        var data = Data()
        data += value
        data += weight
        return data
    }
}
