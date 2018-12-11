import Foundation

class SearchAccountHistory: BaseRequest<[TransactionDetail]> {
    
    required init(accountId: ChainObject,
                  order: SearchAccountHistoryOrder = .TIME_DESC,
                  startId: ChainObject = ObjectType.NULL_OBJECT.genericId,
                  limit: Int = 100) {
        
        guard accountId.objectType == ObjectType.ACCOUNT_OBJECT else { preconditionFailure("not a valid account object id") }
        guard startId == ObjectType.NULL_OBJECT.genericId || startId.objectType == ObjectType.TRANSACTION_DETAIL_OBJECT else {
            preconditionFailure("not a valid null or transaction detail object id")
        }
        super.init(api: .DATABASE, method: "search_account_history", returnClass: [TransactionDetail].self, params: [
            accountId.objectId, order.rawValue, startId.objectId, max(0, min(100, limit))
        ])
    }
}
