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

extension Publishing: DataEncodable {
    func asData() -> Data {
        var data = Data()
        data += isPublishingManager
        data += Data.ofZero
        data += Data.ofZero
        
        Logger.debug(crypto: "Publishing binary: %{private}s", args: { "\(data.toHex()) (\(data))"})
        return data
    }
}
