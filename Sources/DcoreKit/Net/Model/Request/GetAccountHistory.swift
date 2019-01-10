import Foundation

class GetAccountHistory: BaseRequest<[OperationHistory]> {
    
    required init(accountId: ChainObject,
                  stopId: ChainObject = ObjectType.operationHistoryObject.genericId,
                  limit: Int = 100,
                  startId: ChainObject = ObjectType.operationHistoryObject.genericId
        ) {
        
        precondition(accountId.objectType == ObjectType.accountObject, "Not a valid account object id")
        precondition(startId.objectType == ObjectType.operationHistoryObject,"Not a valid history object id")
        
        super.init(.history, api: "get_account_history", returnClass: [OperationHistory].self, params: [
            accountId.objectId, stopId.objectId, max(0, min(100, limit)), startId.objectId
        ])
    }
}
