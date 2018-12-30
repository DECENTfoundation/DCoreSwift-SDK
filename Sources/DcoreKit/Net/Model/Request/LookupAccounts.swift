import Foundation

class LookupAccounts: BaseRequest<[String:ChainObject]> {
 
    required init(_ lowerBound: String, limit: Int = 1000) {
        super.init(.database, api: "lookup_accounts", returnClass: [String:ChainObject].self, params: [lowerBound, limit])
    }
}
