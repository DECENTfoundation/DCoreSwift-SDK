import Foundation
import BigInt

public struct FeeParameter: Codable {
    
    public let fee: AssetAmount?
    public let basicFee: AssetAmount?
    public let pricePerKb: AssetAmount?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fee = try container.decodeIfPresent(BigInt.self, forKey: .fee).map { AssetAmount($0) }
        self.basicFee = try container.decodeIfPresent(BigInt.self, forKey: .basicFee).map { AssetAmount($0) }
        self.pricePerKb = try container.decodeIfPresent(BigInt.self, forKey: .pricePerKb).map { AssetAmount($0) }
    }
    
    private enum CodingKeys: String, CodingKey {
        case
        fee,
        basicFee = "basic_fee",
        pricePerKb = "price_per_kbyte"
    }
}
