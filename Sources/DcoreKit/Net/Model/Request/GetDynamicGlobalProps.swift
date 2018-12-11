import Foundation

class GetDynamicGlobalProps: BaseRequest<DynamicGlobalProps> {
    
    required init() {
        super.init(api: .DATABASE, method: "get_dynamic_global_properties", returnClass: DynamicGlobalProps.self)
    }
}
