import Foundation

class GetTransactionHex: BaseRequest<String> {
    
    required init(transaction: Transaction) {
        super.init(api: .DATABASE, method: "get_transaction_hex", returnClass: String.self, params: [transaction])
    }
}
