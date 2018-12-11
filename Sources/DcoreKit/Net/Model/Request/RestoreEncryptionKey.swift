import Foundation

class RestoreEncryptionKey: BaseRequest<String> {
    
    required init(elGamalPrivate: PubKey, purchaseId: ChainObject) {
        guard purchaseId.objectType == ObjectType.BUYING_OBJECT else { preconditionFailure("not a valid purchase object id") }
        super.init(api: .DATABASE, method: "restore_encryption_key", returnClass: String.self, params: [elGamalPrivate, purchaseId])
    }
}
