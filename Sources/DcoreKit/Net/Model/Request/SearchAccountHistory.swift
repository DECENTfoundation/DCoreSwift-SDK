import Foundation

class SearchAccountHistory: BaseRequest<[TransactionDetail]> {
    
    required init(accountId: ChainObject,
                  order: SearchOrder.AccountHistory = .timeDesc,
                  startId: ChainObject = ObjectType.nullObject.genericId,
                  limit: Int = 100) {
        
        precondition(accountId.objectType == .accountObject, "Not a valid account object id")
        precondition(startId == ObjectType.nullObject.genericId || startId.objectType == .transactionDetailObject,
            "Not a valid null or transaction detail object id"
        )
        super.init(.database, api: "search_account_history", returnClass: [TransactionDetail].self, params: [
            accountId.objectId, order.rawValue, startId.objectId, max(0, min(100, limit))
        ])
    }
}
