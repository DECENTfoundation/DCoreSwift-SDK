import Foundation

class SetContentUpdateCallback: BaseRequest<UnitValue>, WithCallback {
    required init(uri: String) {
        super.init(.database, api: "set_content_update_callback", returnClass: UnitValue.self, params: [uri])
    }
}
