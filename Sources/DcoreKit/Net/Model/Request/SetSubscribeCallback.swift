import Foundation

struct SetSubscribeCallback: BaseRequestConvertible {
    
    typealias Output = UnitValue
    private(set) var base: BaseRequest<UnitValue>
    
    init(_ clear: Bool) {
        self.base = SetSubscribeCallback.toBaseCallback(.database, api: "set_subscribe_callback", returnClass: UnitValue.self, params: [clear])
    }
}
