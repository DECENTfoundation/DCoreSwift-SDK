import Foundation

class GetRealSupply: BaseRequest<RealSupply> {
    
    required init() {
        super.init(api: .DATABASE, method: "get_real_supply", returnClass: RealSupply.self)
    }
}
