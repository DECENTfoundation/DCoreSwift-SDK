import Foundation

struct PriceToDct: BaseRequestConvertible {
    
    typealias Output = AssetAmount
    private(set) var base: BaseRequest<AssetAmount>
    
    init(_ amount: AssetAmount) {
        self.base = PriceToDct.toBase(.database, api: "price_to_dct", returnClass: AssetAmount.self, params: [amount])
    }
}
