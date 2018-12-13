import Foundation

class GetProposedTransactions: BaseRequest<AnyValue> {
    
    required init(accountId: ChainObject) {
        super.init(api: .DATABASE, method: "get_proposed_transactions", returnClass: AnyValue.self, params: [accountId])
    }
}
