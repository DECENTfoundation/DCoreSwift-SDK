import Foundation

class GetVestingBalances:  BaseRequest<[VestingBalance]> {
    
    required init(accountId: ChainObject) {
        guard accountId.objectType == ObjectType.accountObject else { preconditionFailure("not a valid account object id") }
        super.init(.database, api: "get_vesting_balances", returnClass: [VestingBalance].self, params: [accountId.objectId])
    }
}
