import Foundation

struct SearchAccountHistory: BaseRequestConvertible {
    
    typealias Output = [TransactionDetail]
    private(set) var base: BaseRequest<[TransactionDetail]>
    
    init(_ accountId: AccountObjectId,
         order: SearchOrder.AccountHistory = .timeDesc,
         startId: TransactionDetailObjectId? = nil,
         limit: Int = 100) {
        self.base = SearchAccountHistory.toBase(
            .database,
            api: "search_account_history",
            returnType: [TransactionDetail].self,
            params: [
                accountId, order, startId ?? ObjectId.nullObjectId, max(0, min(100, limit))
            ]
        )
    }
}
