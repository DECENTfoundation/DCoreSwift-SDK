import Foundation

struct GetAccountById: BaseRequestConvertible {
    
    typealias Output = [Account]
    private(set) var base: BaseRequest<[Account]>
    
    init(_ ids: [AccountObjectId]) {
        self.base = GetObjects(ids, returnType: [Account].self).base
    }
}
