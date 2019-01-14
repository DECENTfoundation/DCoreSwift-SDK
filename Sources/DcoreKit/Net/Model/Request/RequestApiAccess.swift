import Foundation

struct RequestApiAccess: BaseRequestConvertible {
    
    typealias Output = Int
    private(set) var base: BaseRequest<Int>
    
    init(_ group: ApiGroup) {
        self.base = RequestApiAccess.toBase(.login, api: group.name, returnClass: Int.self, params: [])
    }
}
