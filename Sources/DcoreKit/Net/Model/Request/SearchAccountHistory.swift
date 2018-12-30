import Foundation

class SearchAccountHistory: BaseRequest<[TransactionDetail]> {
    
    required init(accountId: ChainObject,
                  order: SearchAccountHistoryOrder = .TIME_DESC,
                  startId: ChainObject = ObjectType.nullObject.genericId,
                  limit: Int = 100) {
        
        guard accountId.objectType == ObjectType.accountObject else { preconditionFailure("not a valid account object id") }
        guard startId == ObjectType.nullObject.genericId || startId.objectType == ObjectType.transactionDetailObject else {
            preconditionFailure("not a valid null or transaction detail object id")
        }
        super.init(.database, api: "search_account_history", returnClass: [TransactionDetail].self, params: [
            accountId.objectId, order.rawValue, startId.objectId, max(0, min(100, limit))
        ])
    }
}
