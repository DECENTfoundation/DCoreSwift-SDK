import Foundation

class GetAccountCount: BaseRequest<UInt64> {
    
    required init() {
        super.init(.database, api: "get_account_count", returnClass: UInt64.self)
    }
}
