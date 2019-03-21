import Foundation
import RxSwift

public protocol ValidationApi: BaseApi {
    /**
     This API will take a partially signed transaction
     and a set of public keys that the owner has the ability to sign for
     and return the minimal subset of public keys,
     that should add signatures to the transaction.
     
     - Parameter trx: Partially signed transaction.
     - Parameter keys: Available owner public keys.
     
     - Returns: Public keys that should add signatures.
     */
    func getRequiredSignatures(byTransaction trx: Transaction, keys: [Address]) -> Single<[Address]>
    
    /**
     This method will return the set of all public keys,
     that could possibly sign for a given transaction.
     This call can be used by wallets to filter their set of public keys,
     to just the relevant subset prior to calling get_required_signatures(),
     to get the minimum subset.
     
     - Parameter trx: Unsigned transaction.
     
     - Returns: Public keys that can sign transaction.
     */
    func getPotentialSignatures(byTransaction trx: Transaction) -> Single<[Address]>
    
    /**
     Verifies required signatures of a transaction.
     
     - Parameter trx: Signed transaction to verify.
     
     - Returns: `true` if the transaction has all of the required signatures.
     */
    func verifyAuthority(byTransaction trx: Transaction) -> Single<Bool>
    
    /**
     Verifies required signatures of a transaction.
     
     - Parameter ref: Account name or object id.
     - Parameter keys: Signer keys.
     
     - Returns: `true` if the signers have enough authority.
     */
    func verifyAccountAuthority(byReference ref: Account.Reference, keys: [Address]) -> Single<Bool>
   
    /**
     Verifies required signatures of a transaction.
     
     - Parameter ref: Account name or object id.
     - Parameter key: Signer key.
     
     - Returns: `true` if the signers have enough authority.
     */
    func verifyAccountAuthority(byReference ref: Account.Reference, key: Address) -> Single<Bool>
    
    /**
     Verifies required signatures of a transaction.
     
     - Parameter credentials: Account credentials.
     
     - Returns: `true` if the signers have enough authority.
     */
    func verifyAccountAuthority(_ credentials: Credentials) -> Single<Bool>
    
    /**
     Validates a transaction against the current state without broadcasting it on the network.
     
     - Parameter trx: Signed transaction.
     
     - Throws: `DCoreException`, if not valid.
     
     - Returns: `ProcessedTransaction`.
     */
    func validate(byTransaction trx: Transaction) -> Single<ProcessedTransaction>
    
    /**
     Get fees for operations.
     
     - Parameter operations: List of operations.
     - Parameter assetId: Asset id eg. DCT id is 1.3.0,
     as `ChainObject` or `String` format.
     
     - Returns: Arrray `[AssetAmount]` of fee asset amounts
     */
    func getFees(for operations: [Operation], assetId: ChainObjectConvertible) -> Single<[AssetAmount]>
    
    /**
     Get fees for operation.
     
     - Parameter operation: Operation.
     - Parameter assetId: Asset id eg. DCT id is 1.3.0,
     as `ChainObject` or `String` format.
     
     - Returns: `AssetAmount` fee.
     */
    func getFee(for operation: Operation, assetId: ChainObjectConvertible) -> Single<AssetAmount>
    
    /**
     Get fees for operation type.
     Not valid for operation per size fees:
     
     1. OperationType.proposalCreateOperation
     2. OperationType.proposalUpdateOperation
     3. OperationType.withdrawPermissionClaimOperation
     4. OperationType.customOperation

     - Parameter type: Operation type.
     - Parameter assetId: Asset id eg. DCT id is 1.3.0,
     as `ChainObject` or `String` format.
     
     - Returns: `AssetAmount` fee.
     */
    func getFee(forType type: OperationType, assetId: ChainObjectConvertible) -> Single<AssetAmount>
}

extension ValidationApi {
    public func getRequiredSignatures(byTransaction trx: Transaction, keys: [Address]) -> Single<[Address]> {
        return GetRequiredSignatures(trx, keys: keys).base.toResponse(api.core)
    }
    
    public func getPotentialSignatures(byTransaction trx: Transaction) -> Single<[Address]> {
        return GetPotentialSignatures(trx).base.toResponse(api.core)
    }
    
    public func verifyAuthority(byTransaction trx: Transaction) -> Single<Bool> {
        return VerifyAuthority(trx).base.toResponse(api.core).catchErrorJustReturn(false)
    }
    
    public func verifyAccountAuthority(byReference ref: Account.Reference, keys: [Address]) -> Single<Bool> {
        return VerifyAccountAuthority(ref, keys: keys).base.toResponse(api.core).catchError {
            guard $0.asDCoreException().isStack else { throw $0 }
            return Single.just(false)
        }
    }
    
    public func verifyAccountAuthority(byReference ref: Account.Reference, key: Address) -> Single<Bool> {
        return verifyAccountAuthority(byReference: ref, keys: [key])
    }
    
    public func verifyAccountAuthority(_ credentials: Credentials) -> Single<Bool> {
        return verifyAccountAuthority(byReference: credentials.accountId.objectId, key: credentials.keyPair.address)
    }
    
    public func validate(byTransaction trx: Transaction) -> Single<ProcessedTransaction> {
        return ValidateTransaction(trx).base.toResponse(api.core)
    }
    
    public func getFees(for operations: [Operation], assetId: ChainObjectConvertible = DCore.Constant.dct) -> Single<[AssetAmount]> {
        return Single.deferred {
            return GetRequiredFees(operations, assetId: try assetId.asChainObject()).base.toResponse(self.api.core)
        }
    }
    
    public func getFee(for operation: Operation, assetId: ChainObjectConvertible = DCore.Constant.dct) -> Single<AssetAmount> {
        return getFees(for: [operation], assetId: assetId).map { try $0.first.orThrow(DCoreException.network(.notFound)) }
    }
    
    public func getFee(forType type: OperationType, assetId: ChainObjectConvertible = DCore.Constant.dct) -> Single<AssetAmount> {
        precondition(![
            .proposalCreateOperation,
            .proposalUpdateOperation,
            .withdrawPermissionClaimOperation,
            .customOperation
            ].contains(type), "Not supported operation type")
        return getFee(for: FeeOperation(type), assetId: assetId)
    }
}

extension ApiProvider: ValidationApi {}
