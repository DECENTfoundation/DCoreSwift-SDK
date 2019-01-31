import Foundation

struct GetAccountHistory<Input>: BaseRequestConvertible where Input: Operation {
    
    typealias Output = [OperationHistory<Input>]
    private(set) var base: BaseRequest<[OperationHistory<Input>]>
    
    init(_ accountId: ChainObject,
         stopId: ChainObject = ObjectType.operationHistoryObject.genericId,
         limit: UInt64 = 100,
         startId: ChainObject = ObjectType.operationHistoryObject.genericId
        ) {
        
        precondition(accountId.objectType == .accountObject, "Not a valid account object id")
        precondition(startId.objectType == .operationHistoryObject, "Not a valid history object id")
        
        self.base = GetAccountHistory.toBase(
            .history, api: "get_account_history", returnType: [OperationHistory<Input>].self, params: [
                accountId, stopId, max(0, min(100, limit)), startId
            ]
        )
    }
}
