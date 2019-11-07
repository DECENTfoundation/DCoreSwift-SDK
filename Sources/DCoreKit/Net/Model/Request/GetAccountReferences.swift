import Foundation

struct GetAccountReferences: BaseRequestConvertible {
    
    typealias Output = [AccountObjectId]
    private(set) var base: BaseRequest<[AccountObjectId]>
    
    init(_ accountId: AccountObjectId) {
        self.base = GetAccountReferences.toBase(
            .database,
            api: "get_account_references",
            returnType: [AccountObjectId].self,
            params: [accountId]
        )
    }
}
