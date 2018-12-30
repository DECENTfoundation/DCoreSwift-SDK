import Foundation

class GetRealSupply: BaseRequest<RealSupply> {
    
    required init() {
        super.init(.database, api: "get_real_supply", returnClass: RealSupply.self)
    }
}
