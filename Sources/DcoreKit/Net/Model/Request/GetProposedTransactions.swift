import Foundation

class GetProposedTransactions: BaseRequest<[Any]> {
    
    required init(account: ChainObject) {
        super.init(api: .DATABASE, method: "get_proposed_transactions", returnClass: [Any].self, params: [account])
    }
}
