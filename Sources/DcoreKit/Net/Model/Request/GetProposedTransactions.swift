import Foundation

struct GetProposedTransactions: BaseRequestConvertible {
    
    typealias Output = AnyValue
    private(set) var base: BaseRequest<AnyValue>
    
    init(_ accountId: ChainObject) {
        self.base = GetProposedTransactions.toBase(
            .database, api: "get_proposed_transactions", returnClass: AnyValue.self, params: [accountId]
        )
    }
}
