import Foundation
import RxSwift

public final class ValidationApi: BaseApi {
    
    public func getRequiredSignatures(byTrx trx: Transaction, keys: [Address]) -> Single<[Address]> {
        return GetRequiredSignatures(transaction: trx, keys: keys).asCoreRequest(api.core)
    }
    
    public func getPotentialSignatures(byTrx trx: Transaction) -> Single<[Address]> {
        return GetPotentialSignatures(transaction: trx).asCoreRequest(api.core)
    }
    
    public func verifyAuthority(byTrx trx: Transaction) -> Single<Bool> {
        return VerifyAuthority(transaction: trx).asCoreRequest(api.core).catchErrorJustReturn(false)
    }
    
    public func verifyAccountAuthority(account: String, keys: [Address]) -> Single<Bool> {
        return VerifyAccountAuthority(account: account, keys: keys).asCoreRequest(api.core)
    }
    
    public func validateTransaction(byTrx trx: Transaction) -> Single<ProcessedTransaction> {
        return ValidateTransaction(transaction: trx).asCoreRequest(api.core)
    }
    
    public func getFees(forOperations operations: [BaseOperation]) -> Single<[AssetAmount]> {
        return GetRequiredFees(operations: operations).asCoreRequest(api.core)
    }
    
    public func getFee(forOperation operation: BaseOperation) -> Single<AssetAmount> {
        return getFees(forOperations: [operation]).map({ $0.first! })
    }
    
    public func getFee(forType type: OperationType) -> Single<AssetAmount>  {
        guard ![
            .proposalCreateOperation,
            .proposalUpdateOperation,
            .withdrawPermissionClaimOperation,
            .customOperation
            ].contains(type) else { preconditionFailure("not supported operation type") }
        
        return getFee(forOperation: EmptyOperation(type: type))
    }
}
