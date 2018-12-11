import Foundation

class GetGlobalProperties : BaseRequest<GlobalProperty> {
    
    required init() {
        super.init(api: .DATABASE, method: "get_global_properties", returnClass: GlobalProperty.self)
    }
}
