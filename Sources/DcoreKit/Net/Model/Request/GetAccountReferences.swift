import Foundation

struct GetAccountReferences: BaseRequestConvertible {
    
    typealias Output = [ChainObject]
    private(set) var base: BaseRequest<[ChainObject]>
    
    init(_ accountId: ChainObject) {
        self.base = GetAccountReferences.toBase(.database, api: "get_account_references", returnClass: [ChainObject].self, params: [accountId])
    }
}
