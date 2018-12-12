import Foundation

public struct FeeParameter: Codable {
    
    public let fee: AssetAmount
    public var pricePerKb: Int? = nil
    
    private enum CodingKeys: String, CodingKey {
        case
        fee,
        pricePerKb
    }
}
