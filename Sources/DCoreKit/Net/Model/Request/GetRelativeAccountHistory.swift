import Foundation

struct GetRelativeAccountHistory<Input>: BaseRequestConvertible where Input: Operation {
    
    typealias Output = [OperationHistory<Input>]
    private(set) var base: BaseRequest<[OperationHistory<Input>]>
    
    init(_ accountId: ChainObject, stop: Int = 0, limit: Int = 100, start: Int = 0) {
        
        precondition(accountId.objectType == .accountObject, "Not a valid account object id")
        self.base = GetRelativeAccountHistory.toBase(
            .history,
            api: "get_relative_account_history",
            returnType: [OperationHistory].self,
            params: [
                accountId.objectId, stop, max(0, min(100, limit)), start
            ]
        )
    }
}
