import Foundation

struct RestoreEncryptionKey: BaseRequestConvertible {
    
    typealias Output = String
    private(set) var base: BaseRequest<String>
    
    init(_ elGamalPrivate: PubKey, purchaseId: ChainObject) {
        precondition(purchaseId.objectType == .purchaseObject, "Not a valid purchase object id")
        self.base = RestoreEncryptionKey.toBase(
            .database, api: "restore_encryption_key", returnType: String.self, params: [elGamalPrivate, purchaseId]
        )
    }
}
