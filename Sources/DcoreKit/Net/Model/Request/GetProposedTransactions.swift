import Foundation

class GetProposedTransactions: BaseRequest<AnyValue> {
    
    required init(accountId: ChainObject) {
        super.init(.database, api: "get_proposed_transactions", returnClass: AnyValue.self, params: [accountId])
    }
}
