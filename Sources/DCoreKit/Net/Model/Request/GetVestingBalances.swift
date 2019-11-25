import Foundation

struct GetVestingBalances: BaseRequestConvertible {
    
    typealias Output = [VestingBalance]
    private(set) var base: BaseRequest<[VestingBalance]>
    
    init(_ accountId: AccountObjectId) {
        self.base = GetVestingBalances.toBase(
            .database,
            api: "get_vesting_balances",
            returnType: [VestingBalance].self,
            params: [accountId]
        )
    }
}
