import Foundation

class GetVestingBalances:  BaseRequest<[VestingBalance]> {
    
    required init(accountId: ChainObject) {
        
        precondition(accountId.objectType == .accountObject, "Not a valid account object id")
        super.init(.database, api: "get_vesting_balances", returnClass: [VestingBalance].self, params: [accountId.objectId])
    }
}
