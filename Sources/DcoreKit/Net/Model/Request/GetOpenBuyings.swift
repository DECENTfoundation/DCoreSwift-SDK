import Foundation

class GetOpenBuyings : BaseRequest<[Purchase]> {
    
    required init() {
        super.init(api: .DATABASE, method: "get_open_buyings", returnClass: [Purchase].self)
    }
}
