import Foundation

class GetContentByUri: BaseRequest<Content> {

    required init(uri: String) {
        super.init(.database, api: "get_content", returnClass: Content.self, params: [uri])
    }
}
