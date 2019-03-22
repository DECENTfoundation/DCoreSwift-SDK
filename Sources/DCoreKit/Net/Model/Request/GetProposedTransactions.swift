import Foundation

struct GetProposedTransactions: BaseRequestConvertible {
    
    typealias Output = AnyValue
    private(set) var base: BaseRequest<AnyValue>
    
    init(_ accountId: ChainObject) {
        precondition(accountId.objectType == .accountObject, "Not a valid account object id")
        self.base = GetProposedTransactions.toBase(
            .database, api: "get_proposed_transactions", returnType: AnyValue.self, params: [accountId]
        )
    }
}
