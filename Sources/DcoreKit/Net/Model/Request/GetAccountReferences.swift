import Foundation

class GetAccountReferences: BaseRequest<[ChainObject]> {
    
    required init(accountId: ChainObject) {
        super.init(api: .DATABASE, method: "get_account_references", returnClass: [ChainObject].self, params: [accountId])
    }
}
