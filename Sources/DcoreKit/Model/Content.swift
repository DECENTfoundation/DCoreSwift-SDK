import Foundation

public struct Content: Codable {
    
    public let id: ChainObject
    public let author: String
    public let regionalPrice: PricePerRegion
    public let synopsis: String
    public let uri: String
    public let hash: String
    public let rating: Int
    public let size: UInt64
    public let expiration: Date
    public let created: Date
    public let timesBought: Int
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        author,
        regionalPrice,
        synopsis,
        uri = "URI",
        hash = "_hash",
        rating = "AVG_rating",
        size,
        expiration,
        created,
        timesBought = "times_bought"
    }
    
    public var price: AssetAmount {
        guard let value =  regionalPrice.prices[Regions.NONE.id] else {
            fatalError("Regions price NONE does not exist")
        }
        
        return value
    }
}
