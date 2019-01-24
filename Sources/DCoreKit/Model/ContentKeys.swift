import Foundation

public struct ContentKeys: Codable {
    
    public let key: String
    public let keyParts: [KeyParts]
    
    private enum CodingKeys: String, CodingKey {
        case
        key,
        keyParts = "parts"
    }    
}
