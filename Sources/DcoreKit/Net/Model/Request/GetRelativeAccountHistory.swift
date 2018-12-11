import Foundation

class GetRelativeAccountHistory: BaseRequest<[OperationHistory]> {
    
    required init(accountId: ChainObject, stop: Int = 0, limit: Int = 100, start: Int = 0) {
        guard accountId.objectType == ObjectType.ACCOUNT_OBJECT else { preconditionFailure("not a valid account object id") }
        super.init(api: .HISTORY, method: "get_relative_account_history", returnClass: [OperationHistory].self, params: [
            accountId.objectId, stop, max(0, min(100, limit)), start
        ])
    }
}
