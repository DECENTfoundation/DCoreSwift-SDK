import Foundation
import BigInt

private extension Decimal {
    static let zero: Decimal = 0
}

public struct Asset: Codable, AssetFormatting, Equatable {
    
    public var id: AssetObjectId = .genericId()
    
    public var symbol: String = "UIA"
    public var precision: Int = 0
    public var issuer: AccountObjectId = .genericId()
    public var description: String = ""
    public var options: Asset.Options = Asset.Options()
    public var dataId: AssetDataObjectId = .genericId()
    public var monitoredOptions: AnyValue?
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        symbol,
        precision,
        issuer,
        description,
        options,
        dataId = "dynamic_asset_data_id",
        monitoredOptions = "monitored_asset_opts"
    }
    
    /// Converts DCT [amount] according conversion rate.
    public func convert(fromDct amount: BigInt, rounding: Decimal.RoundingMode) throws -> AssetAmount {
        return try convert(amount, to: id, rounding: rounding)
    }
    
    /// Converts asset [amount] to DCT according conversion rate.
    public func convert(toDct amount: BigInt, rounding: Decimal.RoundingMode) throws -> AssetAmount {
        return try convert(amount, to: DCore.Constant.dct, rounding: rounding)
    }
    
    private func convert(_ amount: BigInt, to assetId: AssetObjectId, rounding: Decimal.RoundingMode) throws -> AssetAmount {
        var quote = Decimal(string: options.exchangeRate.quote.amount.description).or(.zero)
        var base = Decimal(string: options.exchangeRate.base.amount.description).or(.zero)
        let value = Decimal(string: amount.description).or(.zero)
        
        precondition(assetId.objectType == .assetObject, "Not valid asset id")
        precondition(quote > .zero, "Quote amount \(quote) must be greater then zero")
        precondition(base > .zero, "Base amount \(base) must be greater then zero")
        
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

    public static func hasValid(symbol: String) -> Bool {
        return !symbol.matches(regex: "(?=.{3,16}$)^[A-Z][A-Z0-9]+(\\.[A-Z0-9]*)?[A-Z]$").isEmpty
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
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self.description)
        }
    }
    
    public struct ExchangeRate: Codable, Equatable, DataConvertible {
        public static let empty: ExchangeRate = ExchangeRate(base: AssetAmount(0), quote: AssetAmount(0))

        public var base: AssetAmount = AssetAmount(with: 1)
        public var quote: AssetAmount = AssetAmount(with: 1)
        
        private enum CodingKeys: String, CodingKey {
            case
            base,
            quote
        }

        public func asData() -> Data {
            var data = Data()
            data += base.asData()
            data += quote.asData()
            
            DCore.Logger.debug(crypto: "Asset.ExchangeRate binary: %{private}s", args: {
                "\(data.toHex()) (\(data)) \(data.bytes)"
            })
            return data
        }

        /**
         quote & base asset ids cannot be the same, for quote any id can be used since it is modified to created
         asset id upon creation
         
         - Parameter dct: base value in DCT
         - Parameter uia: quote value in UIA

         - Returns: `ExchangeRate`
         */
        public static func forCreateOperation(dct: BigInt, uia: BigInt) -> ExchangeRate {
            return ExchangeRate(
                base: AssetAmount(dct),
                quote: AssetAmount(uia, assetId: (try? "1.3.1".asAssetObjectId()).or(.genericId()))
            )
        }
    }
    
    public struct Options: Codable, Equatable, DataConvertible {

        public var maxSupply: BigInt = 0
        public var exchangeRate: ExchangeRate = ExchangeRate()
        public var exchangeable: Bool = false
        public var extensions: FixedMaxSupply?
        
        private enum CodingKeys: String, CodingKey {
            case
            maxSupply = "max_supply",
            exchangeRate = "core_exchange_rate",
            exchangeable = "is_exchangeable",
            extensions
        }
        
        public init() {}

        public init(maxSupply: BigInt, exchangeRate: ExchangeRate, exchangeable: Bool, extensions: FixedMaxSupply?) {
            self.maxSupply = maxSupply
            self.exchangeRate = exchangeRate
            self.exchangeable = exchangeable
            self.extensions = extensions
        }

        public func asData() -> Data {
            var data = Data()
            data += Int64(maxSupply).littleEndian
            data += exchangeRate.asData()
            data += exchangeable.asData()
            data += (extensions != nil).asData()
            if let extensions = extensions {
                data += extensions.index
                data += extensions.isFixedMaxSupply.asData()
            }
            
            DCore.Logger.debug(crypto: "Asset.Options binary: %{private}s", args: {
                "\(data.toHex()) (\(data)) \(data.bytes)"
            })
            return data
        }

        public struct FixedMaxSupply: Codable, Equatable, DataConvertible {
            public let isFixedMaxSupply: Bool
            public let index: UInt8 = 1

            private enum CodingKeys: String, CodingKey {
                case
                isFixedMaxSupply = "is_fixed_max_supply"
            }

            public init(isFixedMaxSupply: Bool) {
                self.isFixedMaxSupply = isFixedMaxSupply
            }

            public init(from decoder: Decoder) throws {
                var mainContainer = try decoder.unkeyedContainer()
                if mainContainer.count.or(0) > 0 {
                    var nestedContainer = try mainContainer.nestedUnkeyedContainer()
                    _ = try nestedContainer.decode(Int.self)
                    let valueContainer = try nestedContainer.nestedContainer(keyedBy: CodingKeys.self)
                    self.isFixedMaxSupply = try valueContainer.decode(Bool.self, forKey: CodingKeys.isFixedMaxSupply)
                } else {
                    self.isFixedMaxSupply = false
                }
            }

            public func encode(to encoder: Encoder) throws {
                var mainContainer = encoder.unkeyedContainer()
                var nestedContainer = mainContainer.nestedUnkeyedContainer()
                try nestedContainer.encode(index)
                var valueContainer = nestedContainer.nestedContainer(keyedBy: CodingKeys.self)
                try valueContainer.encode(isFixedMaxSupply, forKey: CodingKeys.isFixedMaxSupply)
            }
        }
    }

    public struct MonitoredAssetOptions: Codable, Equatable, DataConvertible {
        public var feeds: AnyValue?
        public var currentFeed: PriceFeed = PriceFeed()
        public var currentFeedPublicationTime: Date = Date()
        public var feedLifeTimeSec: UInt32 = 24 * 60 * 60 // 1 day
        public var minimumFeeds: UInt8 = 1
        
        private enum CodingKeys: String, CodingKey {
            case
            feeds,
            currentFeed = "current_feed",
            currentFeedPublicationTime = "current_feed_publication_time",
            feedLifeTimeSec = "feed_lifetime_sec",
            minimumFeeds = "minimum_feeds"
        }
        
        public init() {}

        public struct PriceFeed: Codable, Equatable {
            public var coreExchangeRate: ExchangeRate = ExchangeRate.empty

            private enum CodingKeys: String, CodingKey {
                case
                coreExchangeRate = "core_exchange_rate"
            }
        }

        public func asData() -> Data {
            var data = Data()
            if !feeds.isNil() {
                data += Data.ofOne
            }
            data += currentFeed.coreExchangeRate.asData()
            data += Int32(currentFeedPublicationTime.timeIntervalSince1970).littleEndian
            data += minimumFeeds
            
            DCore.Logger.debug(crypto: "Asset.MonitoredAssetOptions binary: %{private}s", args: {
                "\(data.toHex()) (\(data)) \(data.bytes)"
            })
            return data
        }
    }
}
