import Foundation

class GetPotentialSignatures: BaseRequest<[Address]> {
    
    required init(transaction: Transaction) {
        super.init(api: .DATABASE, method: "get_potential_signatures", returnClass: [Address].self, params: [transaction])
    }
}
