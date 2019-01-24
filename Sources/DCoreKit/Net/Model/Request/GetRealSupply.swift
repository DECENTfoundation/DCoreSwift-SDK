import Foundation

struct GetRealSupply: BaseRequestConvertible {
    
    typealias Output = RealSupply
    private(set) var base: BaseRequest<RealSupply>
    
    init() {
        self.base = GetRealSupply.toBase(.database, api: "get_real_supply", returnType: RealSupply.self)
    }
}
