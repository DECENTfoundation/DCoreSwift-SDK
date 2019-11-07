import Foundation

struct Login: BaseRequestConvertible {
    
    typealias Output = Bool
    private(set) var base: BaseRequest<Bool>
    
    init() {
        self.base = Login.toBase(.login, api: "login", returnType: Bool.self, params: ["", ""])
    }
}
