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

extension KeyParts: DataEncodable {
    func asData() -> Data {
        var data = Data()
        data += keyC1
        data += keyD1
        
        Logger.debug(crypto: "KeyParts binary: %{private}s", args: { "\(data.toHex())(\(data))"})
        return data
    }
}
