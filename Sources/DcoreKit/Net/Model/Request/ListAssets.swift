import Foundation

class ListAssets: BaseRequest<[Asset]> {
    
    required init(lowerBound: String, limit: Int = 100) {
        super.init(api: .DATABASE, method: "list_assets", returnClass: [Asset].self, params: [lowerBound, limit])
    }
}
