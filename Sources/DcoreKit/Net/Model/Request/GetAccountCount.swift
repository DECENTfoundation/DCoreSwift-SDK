import Foundation

struct GetAccountCount: BaseRequestConvertible {
    
    typealias Output = UInt64
    private(set) var base: BaseRequest<UInt64>
    
    init() {
        self.base = GetAccountCount.toBase(.database, api: "get_account_count", returnType: UInt64.self)
    }
}
