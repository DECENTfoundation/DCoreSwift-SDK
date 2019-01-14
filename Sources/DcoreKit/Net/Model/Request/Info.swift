import Foundation

struct Info: BaseRequestConvertible {
    
    typealias Output = String
    private(set) var base: BaseRequest<String>
    
    init() {
        self.base = Info.toBase(.database, api: "info", returnClass: String.self)
    }
}
