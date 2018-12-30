import Foundation

public struct Publishing: Codable {
    
    public let isPublishingManager: Bool
    public let publishRightsReceived: AnyValue?
    public let publishRightsForwarded: AnyValue?
    
    private enum CodingKeys: String, CodingKey {
        case
        isPublishingManager = "is_publishing_manager",
        publishRightsReceived = "publishing_rights_received",
        publishRightsForwarded = "publishing_rights_forwarded"
    }
}

extension Publishing: DataSerializable {
    
    public var serialized: Data {
        var data = Data()
        data += isPublishingManager
        data += Data(count: 1)
        data += Data(count: 1)
        return data
    }
}
