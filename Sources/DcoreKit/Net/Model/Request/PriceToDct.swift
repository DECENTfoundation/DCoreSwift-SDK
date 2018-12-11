import Foundation

class PriceToDct: BaseRequest<AssetAmount> {
    
    required init(amount: AssetAmount) {
        super.init(api: .DATABASE, method: "price_to_dct", returnClass: AssetAmount.self, params: [amount])
    }
}
