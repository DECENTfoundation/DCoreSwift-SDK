import Foundation

class GetDynamicGlobalProps: BaseRequest<DynamicGlobalProps> {
    
    required init() {
        super.init(.database, api: "get_dynamic_global_properties", returnClass: DynamicGlobalProps.self)
    }
}
