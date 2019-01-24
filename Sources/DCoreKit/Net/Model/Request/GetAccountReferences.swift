import Foundation

struct GetAccountReferences: BaseRequestConvertible {
    
    typealias Output = [ChainObject]
    private(set) var base: BaseRequest<[ChainObject]>
    
    init(_ accountId: ChainObject) {
        self.base = GetAccountReferences.toBase(
            .database,
            api: "get_account_references",
            returnType: [ChainObject].self,
            params: [accountId]
        )
    }
}
