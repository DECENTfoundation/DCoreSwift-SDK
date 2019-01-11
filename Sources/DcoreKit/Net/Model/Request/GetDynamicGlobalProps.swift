import Foundation

struct GetDynamicGlobalProps: BaseRequestConvertible {
    
    typealias Output = DynamicGlobalProps
    private(set) var base: BaseRequest<DynamicGlobalProps>
    
    init() {
        self.base = GetDynamicGlobalProps.toBase(.database, api: "get_dynamic_global_properties", returnClass: DynamicGlobalProps.self)
    }
}
