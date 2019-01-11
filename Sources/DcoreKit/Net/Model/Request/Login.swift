import Foundation

struct Login: BaseRequestConvertible {
    
    typealias Output = Bool
    private(set) var base: BaseRequest<Bool>
    
    init(_ consumerId: ChainObject, count: Int) {
        self.base = Login.toBase(.login, api: "login", returnClass: Bool.self, params: ["", ""])
    }
}
