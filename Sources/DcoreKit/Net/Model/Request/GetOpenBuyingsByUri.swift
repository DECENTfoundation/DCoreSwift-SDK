import Foundation

class GetOpenBuyingsByUri: BaseRequest<[Purchase]> {

    required init(uri: String) {
        super.init(api: .DATABASE, method: "get_open_buyings_by_URI", returnClass: [Purchase].self, params: [uri])
    }
}

