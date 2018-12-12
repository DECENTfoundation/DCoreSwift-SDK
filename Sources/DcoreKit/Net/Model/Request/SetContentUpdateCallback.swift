import Foundation

class SetContentUpdateCallback: BaseRequest<Void>, WithCallback {
    
    required init(uri: String) {
        super.init(api: .DATABASE, method: "set_content_update_callback", returnClass: Void.self, params: [uri])
    }
}
