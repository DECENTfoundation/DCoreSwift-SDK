import Foundation

class GetPotentialSignatures: BaseRequest<[Address]> {
    
    required init(transaction: Transaction) {
        super.init(.database, api: "get_potential_signatures", returnClass: [Address].self, params: [transaction])
    }
}
