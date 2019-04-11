import Foundation
import BigInt

public protocol AssetFormatting {
    
    var id: ChainObject { get set }
    var symbol: String { get set }
    var precision: Int { get set }
    
    func from(raw value: BigInt) -> Decimal
    func to(raw value: Decimal) throws -> BigInt
    
    func format(_ value: BigInt, formatter: NumberFormatter?) -> String
}

extension Decimal {
    fileprivate static let ten: Decimal = 10
}

extension AssetFormatting {
    public func from(raw value: BigInt) -> Decimal {
        guard let val = Decimal(string: value.description) else { preconditionFailure("Value can't be converted to decimal") }
        return val / pow(.ten, precision)
    }
    
    public func to(raw value: Decimal) throws -> BigInt {
        guard let val = BigInt((value * pow(.ten, precision)).description)
        else { throw DCoreException.chain(.failConvert("Value can't be converted to bigint")) }
        return val
    }
    
    public func format(_ value: BigInt, formatter: NumberFormatter? = nil) -> String {
        guard let val = (formatter ?? defaultFormatter).string(for: from(raw: value)) else { preconditionFailure("Value can't be forrmatted") }
        return "\(val) \(symbol)"
    }
    
    public func amount(_ value: String) throws -> AssetAmount {
        guard let val = Decimal(string: value) else { preconditionFailure("Value can't be converted to decimal") }
        return try amount(val)
    }
    
    public func amount(_ value: Double) throws -> AssetAmount {
        return try amount(Decimal(value))
    }
    
    public func amount(_ value: Decimal) throws -> AssetAmount {
        return try AssetAmount(to(raw: value), assetId: id)
    }
    
    private var defaultFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = precision
        formatter.usesSignificantDigits = precision > 0
        return formatter
    }
}
