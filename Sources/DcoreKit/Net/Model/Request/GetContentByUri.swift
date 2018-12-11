import Foundation

class GetContentByUri: BaseRequest<Content> {

    required init(uri: String) {
        super.init(api: .DATABASE, method: "get_content", returnClass: Content.self, params: [uri])
    }
}
