import Foundation

class GetRelativeAccountHistory: BaseRequest<[OperationHistory]> {
    
    required init(accountId: ChainObject, stop: Int = 0, limit: Int = 100, start: Int = 0) {
        
        precondition(accountId.objectType == .accountObject, "Not a valid account object id")
        super.init(.history, api: "get_relative_account_history", returnClass: [OperationHistory].self, params: [
            accountId.objectId, stop, max(0, min(100, limit)), start
        ])
    }
}
