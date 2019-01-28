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

extension KeyParts: DataConvertible {
    public func asData() -> Data {
        var data = Data()
        data += keyC1.asData()
        data += keyD1.asData()
        
        DCore.Logger.debug(crypto: "KeyParts binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}
