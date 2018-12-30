import Foundation

class GetGlobalProperties : BaseRequest<GlobalProperty> {
    
    required init() {
        super.init(.database, api: "get_global_properties", returnClass: GlobalProperty.self)
    }
}
