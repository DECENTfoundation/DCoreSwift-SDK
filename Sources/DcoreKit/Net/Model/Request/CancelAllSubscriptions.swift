import Foundation

final class CancelAllSubscriptions: BaseRequest<UnitValue> {
    
    required init() {
        super.init(.database, api: "cancel_all_subscriptions", returnClass: UnitValue.self)
    }
}
