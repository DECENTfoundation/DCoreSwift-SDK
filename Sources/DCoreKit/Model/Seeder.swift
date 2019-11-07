import Foundation
import BigInt

public struct Seeder: Codable {
    
    public let id: PublisherObjectId
    public let freeSpace: BigInt
    public let price: AssetAmount
    public let expiration: Date
    public let pubKey: PubKey
    public let ipfsId: String
    public let stats: SeedingStatsObjectId
    public let rating: Int
    public let regionCode: String
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        freeSpace = "free_space",
        price,
        expiration,
        pubKey,
        ipfsId = "ipfs_ID",
        stats,
        rating,
        regionCode = "region_code"
    }
}
