import Foundation

struct SetContentUpdateCallback: BaseRequestConvertible {
    
    typealias Output = UnitValue
    private(set) var base: BaseRequest<UnitValue>
    
    init(_ uri: String) {
        self.base = SetContentUpdateCallback.toBaseCallback(
            .database, api: "set_content_update_callback", returnType: UnitValue.self, params: [uri]
        )
    }
}
