import Foundation

struct GetGlobalProperties: BaseRequestConvertible {
    
    typealias Output = GlobalProperty
    private(set) var base: BaseRequest<GlobalProperty>
    
    init() {
        self.base = GetGlobalProperties.toBase(.database, api: "get_global_properties", returnClass: GlobalProperty.self)
    }
}
