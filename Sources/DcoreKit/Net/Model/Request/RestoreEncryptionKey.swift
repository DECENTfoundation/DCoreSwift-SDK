import Foundation

class RestoreEncryptionKey: BaseRequest<String> {
    
    required init(elGamalPrivate: PubKey, purchaseId: ChainObject) {
        guard purchaseId.objectType == ObjectType.buyingObject else { preconditionFailure("not a valid purchase object id") }
        super.init(.database, api: "restore_encryption_key", returnClass: String.self, params: [elGamalPrivate, purchaseId])
    }
}
