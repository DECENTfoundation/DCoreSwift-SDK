import Foundation

class CancelAllSubscriptions: BaseRequest<Void> {
    
    required init() {
        super.init(api: .DATABASE, method: "cancel_all_subscriptions", returnClass: Void.self)
    }
}
