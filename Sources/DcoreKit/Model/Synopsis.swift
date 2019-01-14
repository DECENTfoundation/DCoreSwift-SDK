import Foundation

public struct Synopsis: Codable {
    
    public let title: String
    public let description: String
    public let type: ChainObject
    
    private enum CodingKeys: String, CodingKey {
        case
        title,
        description,
        type = "content_type_id"
    }
}
