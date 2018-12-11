import Foundation
import BigInt

public protocol AssetFormatter {
    
    var id: ChainObject { get set }
    var symbol: String { get set }
    var precision: Int { get set }
    
    func from(raw value: BigInt) -> Decimal
    func to(raw value: Decimal) -> BigInt
    func format(_ value: Decimal, maxDecimals: Int) -> String
    func format(raw value: BigInt, maxDecimals: Int) -> String
    
    func amount(_ value: String) -> AssetAmount
    func amount(_ value: Double) -> AssetAmount
    func amount(_ value: Decimal) -> AssetAmount
}

extension AssetFormatter {
    
    public func from(raw value: BigInt) -> Decimal {
        guard let val = Decimal(string: value.description) else {
            preconditionFailure("Value is not Decimal")
        }
        return val
    }
    
    public func to(raw value: Decimal) -> BigInt {
        guard let val = BigInt(value.description) else {
            preconditionFailure("Value is not BigInt")
        }
        return val
    }
    
    public func format(_ value: Decimal, maxDecimals: Int?) -> String {
        return "\(maxDecimals ?? precision) \(symbol)"
    }
    
    public func format(raw value: BigInt, maxDecimals: Int?) -> String {
        return "\(maxDecimals ?? precision) \(symbol)"
    }
    
    public func amount(_ value: Decimal) -> AssetAmount {
        return AssetAmount(amount: to(raw: value), assetId: id)
    }
    
    public func amount(_ value: String) -> AssetAmount {
        guard let val = Decimal(string: value) else {
            preconditionFailure("Value is not decimal")
        }
        
        return amount(val)
    }
    
    public func amount(_ value: Double) -> AssetAmount {
        return amount(Decimal(value))
    }
}
