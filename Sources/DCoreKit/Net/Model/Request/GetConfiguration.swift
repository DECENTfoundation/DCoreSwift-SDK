import Foundation

struct GetConfiguration: BaseRequestConvertible {
    
    typealias Output = Config
    private(set) var base: BaseRequest<Config>
    
    init() {
        self.base = GetConfiguration.toBase(.database, api: "get_configuration", returnType: Config.self)
    }
}
