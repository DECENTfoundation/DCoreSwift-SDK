import Foundation

class GetFullAccounts: BaseRequest<[String:FullAccount]> {
    
    required init(namesOrIds: [String], subscribe: Bool) {
        super.init(.database, api: "get_full_accounts", returnClass: [String:FullAccount].self, params:[namesOrIds, subscribe])
    }
}
