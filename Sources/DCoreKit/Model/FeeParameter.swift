import Foundation
import BigInt

public struct FeeParameter: Codable {
    
    public var fee: AssetAmount?
    public var basicFee: AssetAmount?
    public var pricePerKb: AssetAmount?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let fee = try container.decodeIfPresent(BigInt.self, forKey: .fee) {
            self.fee = AssetAmount(fee)
        }
        if let fee = try container.decodeIfPresent(BigInt.self, forKey: .basicFee) {
            self.basicFee = AssetAmount(fee)
        }
        if let fee = try container.decodeIfPresent(BigInt.self, forKey: .pricePerKb) {
            self.pricePerKb = AssetAmount(fee)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case
        fee,
        basicFee = "basic_fee",
        pricePerKb = "price_per_kbyte"
    }
}
