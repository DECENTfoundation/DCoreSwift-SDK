import Foundation

class GetRequiredSignatures: BaseRequest<[Address]> {
 
    required init(transaction: Transaction, keys: [Address]) {
        super.init(api: .DATABASE, method: "get_required_signatures", returnClass: [Address].self, params: [transaction, keys])
    }
}
