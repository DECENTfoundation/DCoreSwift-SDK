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

extension Publishing: ByteSerializable {
    public var bytes: [UInt8] {
        fatalError("Not implemented")
        
        /*
         get() = Bytes.concat(
         isPublishingManager.bytes(),
         byteArrayOf(0),
         byteArrayOf(0)
         */
    }
}

