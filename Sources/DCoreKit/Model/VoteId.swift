import Foundation

public typealias VoteId = String

// swiftlint:disable shorthand_operator

extension VoteId {
    func asVoteData() -> Data {
        let results = matches(regex: "(\\d+)").compactMap { Int($0) }
        guard let last = results.last, let first = results.first else { return Data.ofZero }
        return Data() + Int((last << 8) | first)
    }
}

extension Set where Element == VoteId {
    func asVoteData() -> Data {
        guard !isEmpty else { return Data.ofZero }
        return reduce(into: UInt64(count).asUnsignedVarIntData(), { data, element in
            data = data + element.asVoteData()
        })
    }
}
