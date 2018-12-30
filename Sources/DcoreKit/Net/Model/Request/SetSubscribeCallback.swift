import Foundation

class SetSubscribeCallback: BaseRequest<UnitValue>, WithCallback {
    
    required init(clearFilter: Bool) {
        super.init(.database, api: "set_subscribe_callback", returnClass: UnitValue.self, params: [clearFilter])
    }
}
