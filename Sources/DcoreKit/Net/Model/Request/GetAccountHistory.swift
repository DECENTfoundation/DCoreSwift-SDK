import Foundation

class GetAccountHistory: BaseRequest<[OperationHistory]> {
    
    required init(accountId: ChainObject,
                  stopId: ChainObject = ObjectType.OPERATION_HISTORY_OBJECT.genericId,
                  limit: Int = 100,
                  startId: ChainObject = ObjectType.OPERATION_HISTORY_OBJECT.genericId
        ) {
        
        guard accountId.objectType == ObjectType.ACCOUNT_OBJECT else { preconditionFailure("not a valid account object id") }
        guard startId.objectType == ObjectType.OPERATION_HISTORY_OBJECT else { preconditionFailure("not a valid history object id") }
        
        super.init(api: .HISTORY, method: "get_account_history", returnClass: [OperationHistory].self, params: [
            accountId.objectId, stopId.objectId, max(0, min(100, limit)), startId.objectId
        ])
    }
}
