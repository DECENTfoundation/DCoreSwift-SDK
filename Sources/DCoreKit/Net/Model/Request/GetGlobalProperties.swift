import Foundation

struct GetGlobalProperties: BaseRequestConvertible {
    
    typealias Output = GlobalProperties
    private(set) var base: BaseRequest<GlobalProperties>
    
    init() {
        self.base = GetGlobalProperties.toBase(
            .database, api: "get_global_properties", returnType: GlobalProperties.self
        )
    }
}
