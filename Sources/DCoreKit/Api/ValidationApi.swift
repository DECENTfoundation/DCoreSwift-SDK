import Foundation
import RxSwift

public protocol ValidationApi: BaseApi {
    func getRequiredSignatures(byTrx trx: Transaction, keys: [Address]) -> Single<[Address]>
    func getPotentialSignatures(byTrx trx: Transaction) -> Single<[Address]>
    func verifyAuthority(byTrx trx: Transaction) -> Single<Bool>
    func verifyAccountAuthority(byReference ref: Account.Reference, keys: [Address]) -> Single<Bool>
    func verifyAccountAuthority(byReference ref: Account.Reference, key: Address) -> Single<Bool>
    func verifyAccountAuthority(_ creds: Credentials) -> Single<Bool>
    func validateTransaction(byTrx trx: Transaction) -> Single<ProcessedTransaction>
    func getFees(for operations: [Operation]) -> Single<[AssetAmount]>
    func getFee(for operation: Operation) -> Single<AssetAmount>
    func getFee(forType type: OperationType) -> Single<AssetAmount>
}

extension ValidationApi {
    public func getRequiredSignatures(byTrx trx: Transaction, keys: [Address]) -> Single<[Address]> {
        return GetRequiredSignatures(trx, keys: keys).base.toResponse(api.core)
    }
    
    public func getPotentialSignatures(byTrx trx: Transaction) -> Single<[Address]> {
        return GetPotentialSignatures(trx).base.toResponse(api.core)
    }
    
    public func verifyAuthority(byTrx trx: Transaction) -> Single<Bool> {
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
    
    public func verifyAccountAuthority(_ creds: Credentials) -> Single<Bool> {
        return verifyAccountAuthority(byReference: creds.accountId.objectId, key: creds.keyPair.address)
    }
    
    public func validateTransaction(byTrx trx: Transaction) -> Single<ProcessedTransaction> {
        return ValidateTransaction(trx).base.toResponse(api.core)
    }
    
    public func getFees(for operations: [Operation]) -> Single<[AssetAmount]> {
        return GetRequiredFees(operations).base.toResponse(api.core)
    }
    
    public func getFee(for operation: Operation) -> Single<AssetAmount> {
        return getFees(for: [operation]).map({ try $0.first.orThrow(DCoreException.network(.notFound)) })
    }
    
    public func getFee(forType type: OperationType) -> Single<AssetAmount> {
        precondition(![
            .proposalCreateOperation,
            .proposalUpdateOperation,
            .withdrawPermissionClaimOperation,
            .customOperation
            ].contains(type), "Not supported operation type")
        return getFee(for: FeeOperation(type))
    }
}

extension ApiProvider: ValidationApi {}
