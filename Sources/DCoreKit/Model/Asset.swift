import Foundation
import BigInt

public struct Asset: Codable, AssetFormatting {
    
    public var id: ChainObject = ObjectType.assetObject.genericId {
        willSet { precondition(newValue.objectType == ObjectType.assetObject, "Asset id \(newValue) is not object asset type") }
    }
    
    public var symbol: String = "UIA"
    public var precision: Int = 0
    public var issuer: ChainObject = ObjectType.nullObject.genericId
    public var description: String = ""
    public var options: Asset.Options = Asset.Options()
    public var dataId: ChainObject = ObjectType.nullObject.genericId
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        symbol,
        precision,
        issuer,
        description,
        options,
        dataId = "dynamic_asset_data_id"
    }
    
    public func convert(from assetAmount: AssetAmount) throws -> AssetAmount {
        if options.exchangeRate.base.assetId == assetAmount.assetId {
            let amount = options.exchangeRate.quote.amount / options.exchangeRate.base.amount * assetAmount.amount
            return AssetAmount(amount, assetId: id)
        }
        if options.exchangeRate.base.assetId == assetAmount.assetId {
            let amount = options.exchangeRate.base.amount / options.exchangeRate.quote.amount * assetAmount.amount
            return AssetAmount(amount, assetId: id)
        }
        
        throw DCoreException.chain(.failConvert("Cannot convert \(assetAmount.assetId) with \(symbol):\(id)"))
    }
}

extension Asset {
    
    public enum Symbol: CustomStringConvertible, Encodable, Hashable {
        
        public static let alxt: Symbol = Symbol(name: .alxt)
        public static let alat: Symbol = Symbol(name: .alat)
        public static let alx: Symbol = Symbol(name: .alx)
        public static let aia: Symbol = Symbol(name: .aia)
        public static let dct: Symbol = Symbol(name: .dct)
        
        private enum SymbolName: String {
            case
            alxt = "ALXT",
            alat = "ALAT",
            alx = "ALX",
            aia = "AIA",
            dct = "DCT"
        }
        
        private init(name: SymbolName) {
            self = .from(name.rawValue)
        }
        
        case
        from(String)
        
        public var description: String {
            switch self {
            case .from(let value): return value
            }
        }
        
        public var chainObject: ChainObject {
            return description.dcore.chainObject!
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self.description)
        }
    }
    
    public struct ExchangeRate: Codable {
        
        public var base: AssetAmount = AssetAmount(with: 1)
        public var quote: AssetAmount = AssetAmount(with: 1)
        
        private enum CodingKeys: String, CodingKey {
            case
            base,
            quote
        }
    }
    
    public struct Options: Codable {
        
        public var maxSupply: BigInt = 0
        public var exchangeRate: ExchangeRate = ExchangeRate()
        public var exchangeable: Bool = false
        public var extensions: AnyValue?
        
        private enum CodingKeys: String, CodingKey {
            case
            maxSupply = "max_supply",
            exchangeRate = "core_exchange_rate",
            exchangeable = "is_exchangeable",
            extensions
        }
        
        public init() {}
    }
}
