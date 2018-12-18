import Foundation

public struct KeyParts: Codable {
    public let keyC1: PubKey
    public let keyD1: PubKey
    
    private enum CodingKeys: String, CodingKey {
        case
        keyC1 = "C1",
        keyD1 = "D1"
    }
}

extension KeyParts: DataSerializable {
    public var serialized: Data {
        var data = Data()
        data += keyC1
        data += keyD1
        return data
    }
}
