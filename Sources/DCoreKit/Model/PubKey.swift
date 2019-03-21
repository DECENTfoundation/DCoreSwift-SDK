import Foundation
import BigInt

public struct PubKey: Codable {
    public var value: BigInt = 0
    
    public init(key: String? = nil) {
        if let key = key?.replacingOccurrences(of: ".", with: ""), let value = BigInt(key) {
            self.value = value
        }
    }
    
    public init(_ value: BigInt) {
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let key = try container.decode(String.self, forKey: .key)
        self.init(key: key)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(description, forKey: .key)
    }
    
    private enum CodingKeys: String, CodingKey {
        case
        key = "s"
    }
}

extension PubKey: CustomStringConvertible {
    public var description: String {
        return "\(value)."
    }
}

extension PubKey: DataConvertible {
    public func asData() -> Data {
        var data = Data()
        data += description.asData()
    
        DCore.Logger.debug(crypto: "PubKey binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}
