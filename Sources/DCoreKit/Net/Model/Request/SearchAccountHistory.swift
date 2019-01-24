import Foundation

struct SearchAccountHistory: BaseRequestConvertible {
    
    typealias Output = [TransactionDetail]
    private(set) var base: BaseRequest<[TransactionDetail]>
    
    init(_ accountId: ChainObject,
         order: SearchOrder.AccountHistory = .timeDesc,
         startId: ChainObject = ObjectType.nullObject.genericId,
         limit: Int = 100) {
        
        precondition(accountId.objectType == .accountObject, "Not a valid account object id")
        precondition(startId == ObjectType.nullObject.genericId || startId.objectType == .transactionDetailObject,
                     "Not a valid null or transaction detail object id"
        )
        self.base = SearchAccountHistory.toBase(
            .database,
            api: "search_account_history",
            returnType: [TransactionDetail].self,
            params: [
                accountId, order, startId, max(0, min(100, limit))
            ]
        )
    }
}
