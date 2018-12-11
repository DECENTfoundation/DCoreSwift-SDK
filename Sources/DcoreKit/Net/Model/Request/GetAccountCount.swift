import Foundation

class GetAccountCount: BaseRequest<UInt64> {
    
    required init() {
        super.init(api: .DATABASE, method: "get_account_count", returnClass: UInt64.self)
    }
}
