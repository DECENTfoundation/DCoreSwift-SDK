import Foundation

public struct ContentKeys {
    
    public let key: String
    public let keyParts: [KeyParts]
    
    private enum CodingKeys: String, CodingKey {
        case
        key,
        parts
    }    
}
