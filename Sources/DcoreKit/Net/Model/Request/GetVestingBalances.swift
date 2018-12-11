import Foundation

class GetVestingBalances:  BaseRequest<[VestingBalance]> {
    
    required init(accountId: ChainObject) {
        guard accountId.objectType == ObjectType.ACCOUNT_OBJECT else { preconditionFailure("not a valid account object id") }
        super.init(api: .DATABASE, method: "get_vesting_balances", returnClass: [VestingBalance].self, params: [accountId.objectId])
    }
}
