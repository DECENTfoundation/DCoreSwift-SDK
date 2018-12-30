import Foundation

class GetAccountReferences: BaseRequest<[ChainObject]> {
    
    required init(_ accountId: ChainObject) {
        super.init(.database, api: "get_account_references", returnClass: [ChainObject].self, params: [accountId])
    }
}
