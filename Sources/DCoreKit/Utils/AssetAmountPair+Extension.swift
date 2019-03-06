import Foundation

public extension Pair where A == Asset, B == AssetAmount {
    var asset: Asset { return first }
    var amount: AssetAmount { return second }

    func format(formatter: NumberFormatter? = nil) -> String {
        return first.format(second.amount, formatter: formatter)
    }
}

extension Pair: Equatable where A: Equatable, B: Equatable {
    public static func == (lhs: Pair<A, B>, rhs: Pair<A, B>) -> Bool {
        return lhs.first == rhs.first && lhs.second == rhs.second
    }
}
