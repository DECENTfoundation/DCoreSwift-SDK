import Foundation

class LookupMinerAccounts: BaseRequest<[MinerId]> {
    
    required init(lookupTerm: String = "", limit: Int = 1000) {
        super.init(api: .DATABASE, method: "lookup_miner_accounts", returnClass: [MinerId].self, params: [lookupTerm, limit])
    }
}
