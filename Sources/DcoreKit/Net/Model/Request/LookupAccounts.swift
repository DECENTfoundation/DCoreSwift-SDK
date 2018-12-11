import Foundation

class LookupAccounts: BaseRequest<[String:ChainObject]> {
 
    required init(lowerBound: String, limit: Int = 1000) {
        super.init(api: .DATABASE, method: "lookup_accounts", returnClass: [String:ChainObject].self, params: [lowerBound, limit])
    }
}
