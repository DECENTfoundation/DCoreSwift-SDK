import Foundation

public struct Asset: Codable, AssetFormatter {

    public var id: ChainObject = ObjectType.ASSET_OBJECT.genericId {
        willSet {
            guard newValue.objectType == ObjectType.ASSET_OBJECT else { preconditionFailure("Asset id is not object asset type") }
        }
    }
    public var symbol: String = "UIA"
    public var precision: Int = 0
    public var issuer: ChainObject = ObjectType.NULL_OBJECT.genericId
    public var description: String = ""
    public var options: Options = Options()
    public var dataId: ChainObject = ObjectType.NULL_OBJECT.genericId
    
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
        if (options.exchangeRate.base.assetId == assetAmount.assetId) {
            let amount = options.exchangeRate.quote.amount / options.exchangeRate.base.amount * assetAmount.amount
            return AssetAmount(amount: amount, assetId: id)
        }
        if (options.exchangeRate.base.assetId == assetAmount.assetId) {
            let amount = options.exchangeRate.base.amount / options.exchangeRate.quote.amount * assetAmount.amount
            return AssetAmount(amount: amount, assetId: id)
        }
        
        throw ChainError.illegal("cannot convert \(assetAmount.assetId) with \(symbol):\(id)")
    }
}

extension Asset {

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
        
        public var maxSupply: UInt64 = 0
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
    }
}
