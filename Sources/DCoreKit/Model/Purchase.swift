import Foundation

public struct Purchase: Codable {
    
    public let id: ChainObject
    public let author: String
    public let uri: String
    public let synopsisJson: String
    public let price: AssetAmount
    public let priceBefore: AssetAmount
    public let priceAfter: AssetAmount
    public let seedersAnswered: [ChainObject]
    public let size: Int
    public let comment: String
    public let expiration: Date
    public let pubElGamalKey: PubKey
    public let keyParticles: [KeyParts]
    public let expired: Bool
    public let delivered: Bool
    public let deliveryExpiration: Date
    public let ratedOrCommented: Bool
    public let created: Date
    public let regionFrom: Int
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        author = "consumer",
        uri = "URI",
        synopsisJson = "synopsis",
        price,
        priceBefore = "paid_price_before_exchange",
        priceAfter = "paid_price_after_exchange",
        seedersAnswered = "seeders_answered",
        size,
        comment,
        expiration = "expiration_time",
        pubElGamalKey = "pubKey",
        keyParticles = "key_particles",
        expired,
        delivered,
        deliveryExpiration = "expiration_or_delivery_time",
        ratedOrCommented = "rated_or_commented",
        created,
        regionFrom = "region_code_from"
    }
    
    public func synopsis() throws -> Synopsis? {
        return try JSONDecoder().decode(Synopsis.self, from: synopsisJson.data(using: .utf8)!)
    }
}
