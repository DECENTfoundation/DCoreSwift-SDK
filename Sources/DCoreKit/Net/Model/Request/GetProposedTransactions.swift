import Foundation

struct GetProposedTransactions: BaseRequestConvertible {
    
    typealias Output = AnyValue
    private(set) var base: BaseRequest<AnyValue>
    
    init(_ accountId: AccountObjectId) {
        self.base = GetProposedTransactions.toBase(
            .database, api: "get_proposed_transactions", returnType: AnyValue.self, params: [accountId]
        )
    }
}
