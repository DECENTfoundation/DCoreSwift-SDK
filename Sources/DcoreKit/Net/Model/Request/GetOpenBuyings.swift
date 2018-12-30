import Foundation

class GetOpenBuyings : BaseRequest<[Purchase]> {
    
    required init() {
        super.init(.database, api: "get_open_buyings", returnClass: [Purchase].self)
    }
}
