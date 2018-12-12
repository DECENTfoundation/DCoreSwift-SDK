import Foundation

class SetSubscribeCallback: BaseRequest<Void>, WithCallback {
    
    required init(clearFilter: Bool) {
        super.init(api: .DATABASE, method: "set_subscribe_callback", returnClass: Void.self, params: [clearFilter])
    }
}
