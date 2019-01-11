import Foundation

struct CancelAllSubscriptions: BaseRequestConvertible {
    
    typealias Output = UnitValue
    private(set) var base: BaseRequest<UnitValue>
    
    init(){
        self.base = CancelAllSubscriptions.toBase(.database, api: "cancel_all_subscriptions", returnClass: UnitValue.self)
    }
}
