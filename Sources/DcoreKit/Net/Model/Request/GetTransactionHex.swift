import Foundation

class GetTransactionHex: BaseRequest<String> {
    
    required init(transaction: Transaction) {
        super.init(.database, api: "get_transaction_hex", returnClass: String.self, params: [transaction])
    }
}
