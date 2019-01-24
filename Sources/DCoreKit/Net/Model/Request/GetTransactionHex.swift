import Foundation

struct GetTransactionHex: BaseRequestConvertible {
    
    typealias Output = String
    private(set) var base: BaseRequest<String>
    
    init<Input>(_ trx: Transaction<Input>) where Input: Operation {
        self.base = GetTransactionHex.toBase(
            .database, api: "get_transaction_hex", returnType: String.self, params: [trx]
        )
    }
}
