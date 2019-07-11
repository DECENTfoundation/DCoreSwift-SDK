import Foundation

public struct RegionalPrice: Codable {
    
    public static let unset = RegionalPrice(.unset)
    
    public let price: AssetAmount
    public let region: UInt32
    
    init(_ price: AssetAmount, region: UInt32 = Regions.all.id) {
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
    
    public let prices: [UInt32: AssetAmount]
    
    private enum CodingKeys: String, CodingKey {
        case
        prices = "map_price"
    }

    public init(from decoder: Decoder) throws {
        var container = try decoder.container(keyedBy: CodingKeys.self).nestedUnkeyedContainer(forKey: .prices)
        self.prices = try container.decode([UInt32: AssetAmount].self)
    }
}

public enum Regions {
    
    public static let null: Regions = Regions.code("null", 0)
    public static let none: Regions = Regions.code("", 1)
    public static let all: Regions = Regions.code("default", 2)
    
    case code(String, UInt32)
    
    public var id: UInt32 {
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
