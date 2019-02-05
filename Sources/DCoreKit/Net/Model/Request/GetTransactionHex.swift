import Foundation

struct GetTransactionHex: BaseRequestConvertible {
    
    typealias Output = String
    private(set) var base: BaseRequest<String>
    
    init(_ trx: Transaction) {
        self.base = GetTransactionHex.toBase(
            .database, api: "get_transaction_hex", returnType: String.self, params: [trx]
        )
    }
}
