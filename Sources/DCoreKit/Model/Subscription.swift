import Foundation

public struct Subscription: Codable {

    public let id: SubscriptionObjectId
    public let from: AccountObjectId
    public let to: AccountObjectId
    public let expiration: Date
    public let renewal: Bool
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        from,
        to,
        expiration,
        renewal = "automatic_renewal"
    }
}
