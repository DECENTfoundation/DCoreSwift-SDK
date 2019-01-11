import Foundation

struct GetConfig: BaseRequestConvertible {
    
    typealias Output = Config
    private(set) var base: BaseRequest<Config>
    
    init() {
        self.base = GetConfig.toBase(.database, api: "get_config", returnClass: Config.self)
    }
}
