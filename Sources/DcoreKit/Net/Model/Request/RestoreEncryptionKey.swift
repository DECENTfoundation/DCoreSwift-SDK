import Foundation

class RestoreEncryptionKey: BaseRequest<String> {
    
    required init(elGamalPrivate: PubKey, purchaseId: ChainObject) {
        
        precondition(purchaseId.objectType == .buyingObject, "Not a valid purchase object id")
        super.init(.database, api: "restore_encryption_key", returnClass: String.self, params: [elGamalPrivate, purchaseId])
    }
}
