import Foundation

public struct MinerId: Codable {
    
    public let id: MinerObjectId
    public let name: String
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        name
    }
}
