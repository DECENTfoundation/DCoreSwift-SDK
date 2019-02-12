import Foundation

public extension Pair where A == Asset, B == AssetAmount {
    var asset: Asset { return first }
    var amount: AssetAmount { return second }

    func format(formatter: NumberFormatter? = nil) -> String {
        return first.format(second.amount, formatter: formatter)
    }
}
