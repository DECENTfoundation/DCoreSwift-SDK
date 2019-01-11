import Foundation

struct LookupAccountNames: BaseRequestConvertible {
    
    typealias Output = [Account]
    private(set) var base: BaseRequest<[Account]>
    
    init(_ names: [String]) {
        self.base = LookupAccountNames.toBase(.database, api: "lookup_account_names", returnClass: [Account].self, params: [names])
    }
}
