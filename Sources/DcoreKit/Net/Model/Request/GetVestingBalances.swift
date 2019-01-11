import Foundation

struct GetVestingBalances: BaseRequestConvertible {
    
    typealias Output = [VestingBalance]
    private(set) var base: BaseRequest<[VestingBalance]>
    
    init(_ accountId: ChainObject) {
        
        precondition(accountId.objectType == .accountObject, "Not a valid account object id")
        self.base = GetVestingBalances.toBase(.database, api: "get_vesting_balances", returnClass: [VestingBalance].self, params: [accountId.objectId])
    }
}
