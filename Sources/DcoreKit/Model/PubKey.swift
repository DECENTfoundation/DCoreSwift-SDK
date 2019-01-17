import Foundation
import BigInt

public struct PubKey: Codable {
    
    public var key: BigInt = 0
    
    public init(key: String? = nil) {
        self.key = BigInt(key!).or(0)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let key = try container.decode(String.self)
        
        self.init(key: key)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}

extension PubKey: CustomStringConvertible {
    public var description: String {
        return "\(key)."
    }
}

extension PubKey: DataEncodable {
    func asData() -> Data {
        var data = Data()
        data += VarInt(description.data(using: .ascii)!.count).asData()
        data += description.data(using: .ascii)
        
        Logger.debug(crypto: "PubKey binary: %{private}s", args: { "\(data.toHex()) (\(data))"})
        return data
    }
}
