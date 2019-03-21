import Foundation
import BigInt

private extension Decimal {
    static let zero: Decimal = 0
}

public struct Asset: Codable, AssetFormatting, Equatable {
    
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
    
    /// Converts DCT [amount] according conversion rate.
    public func convert(fromDct amount: BigInt, rounding: Decimal.RoundingMode) throws -> AssetAmount {
        return try convert(amount, to: id, rounding: rounding)
    }
    
    /// Converts asset [amount] to DCT according conversion rate.
    public func convert(toDct amount: BigInt, rounding: Decimal.RoundingMode) throws -> AssetAmount {
        return try convert(amount, to: DCore.Constant.dct, rounding: rounding)
    }
    
    private func convert(_ amount: BigInt, to assetId: ChainObject, rounding: Decimal.RoundingMode) throws -> AssetAmount {
        var quote = Decimal(string: options.exchangeRate.quote.amount.description).or(.zero)
        var base = Decimal(string: options.exchangeRate.base.amount.description).or(.zero)
        let value = Decimal(string: amount.description).or(.zero)
        
        precondition(assetId.objectType == .assetObject, "Not valid asset id")
        precondition(quote > .zero, "Quote amount \(quote) must be greater then zero")
        precondition(quote > .zero, "Base amount \(base) must be greater then zero")
        
        var result: Decimal = .zero
        var error: Decimal.CalculationError = .divideByZero
        
        if options.exchangeRate.quote.assetId == assetId {
            var fragment = quote * value
            error = NSDecimalDivide(&result, &fragment, &base, rounding)
        } else if options.exchangeRate.base.assetId == assetId {
            var fragment = base * value
            error = NSDecimalDivide(&result, &fragment, &quote, rounding)
        }
        
        guard case .noError = error, let converted = BigInt(result.description) else {
             throw DCoreException.chain(.failConvert("Cannot convert \(amount) to asset id \(assetId)"))
        }
        return AssetAmount(converted, assetId: assetId)
    }
}

extension Asset: Hashable {
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}

extension Asset {
    
    public enum Symbol: CustomStringConvertible, Encodable, Hashable, Equatable {
        
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
    
    public struct ExchangeRate: Codable, Equatable {
        
        public var base: AssetAmount = AssetAmount(with: 1)
        public var quote: AssetAmount = AssetAmount(with: 1)
        
        private enum CodingKeys: String, CodingKey {
            case
            base,
            quote
        }
    }
    
    public struct Options: Codable, Equatable {
        
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
