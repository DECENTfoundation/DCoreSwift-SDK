import Foundation

class PriceToDct: BaseRequest<AssetAmount> {
    
    required init(amount: AssetAmount) {
        super.init(.database, api: "price_to_dct", returnClass: AssetAmount.self, params: [amount])
    }
}
