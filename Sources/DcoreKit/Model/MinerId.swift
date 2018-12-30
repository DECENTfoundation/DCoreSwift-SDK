import Foundation

public struct MinerId: Codable {
    
    public let id: ChainObject
    public let name: String
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        name
    }
}
