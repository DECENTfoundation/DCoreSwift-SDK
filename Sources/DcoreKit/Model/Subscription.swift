import Foundation

public struct Subscription: Codable {

    public let from: ChainObject
    public let to: ChainObject
    public let expiration: Date
    public let renewal: Bool
    
    private enum CodingKeys: String, CodingKey {
        case
        from,
        to,
        expiration,
        renewal = "automatic_renewal"
    }
}
