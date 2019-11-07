import Foundation

struct GetAccountHistory: BaseRequestConvertible {
    
    typealias Output = [OperationHistory]
    private(set) var base: BaseRequest<[OperationHistory]>
    
    init(_ accountId: AccountObjectId,
         stopId: OperationHistoryObjectId = ObjectType.operationHistoryObject.genericId(),
         limit: UInt64 = 100,
         startId: OperationHistoryObjectId = ObjectType.operationHistoryObject.genericId()
        ) {        
        self.base = GetAccountHistory.toBase(
            .history, api: "get_account_history", returnType: [OperationHistory].self, params: [
                accountId, stopId, max(0, min(100, limit)), startId
            ]
        )
    }
}
