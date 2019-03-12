import Foundation

public struct RegionalPrice: Codable {
    
    public static let unset = RegionalPrice(.unset)
    
    public let price: AssetAmount
    public let region: Int
    
    init(_ price: AssetAmount, region: Int = Regions.null.id) {
        self.price = price
        self.region = region
    }
    
    private enum CodingKeys: String, CodingKey {
        case
        price,
        region
    }
}

extension RegionalPrice: DataConvertible {
    public func asData() -> Data {
        var data = Data()
        data += region.littleEndian
        data += price.asData()
        
        DCore.Logger.debug(crypto: "RegionalPrice binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}

public struct PricePerRegion: Codable {
    
    public let prices: [Int: AssetAmount]
    
    private enum CodingKeys: String, CodingKey {
        case
        prices = "map_price"
    }
}

public enum Regions {
    
    public static let null: Regions = Regions.code("null", 0)
    public static let none: Regions = Regions.code("", 1)
    public static let all: Regions = Regions.code("default", 2)
    
    case code(String, Int)
    
    public var id: Int {
        switch self {
        case let .code(_, value): return value
        }
    }
    
    public var code: String {
        switch self {
        case let .code(value, _): return value
        }
    }
    
}
