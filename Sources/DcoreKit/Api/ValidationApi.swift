import Foundation
import RxSwift

public protocol ValidationApi: BaseApi {
    func getRequiredSignatures<Input>(byTrx trx: Transaction<Input>, keys: [Address]) -> Single<[Address]> where Input: Operation
    func getPotentialSignatures<Input>(byTrx trx: Transaction<Input>) -> Single<[Address]> where Input: Operation
    func verifyAuthority<Input>(byTrx trx: Transaction<Input>) -> Single<Bool> where Input: Operation
    func verifyAccountAuthority(byAccount account: String, keys: [Address]) -> Single<Bool>
    func validateTransaction<Input>(byTrx trx: Transaction<Input>) -> Single<ProcessedTransaction<Input>> where Input: Operation
    func getFees<Input>(for operations: [Input]) -> Single<[AssetAmount]> where Input: Operation
    func getFee<Input>(for operation: Input) -> Single<AssetAmount> where Input: Operation
    func getFee(forType type: OperationType) -> Single<AssetAmount>
}

extension ValidationApi {
    public func getRequiredSignatures<Input>(byTrx trx: Transaction<Input>,
                                             keys: [Address]) -> Single<[Address]> where Input: Operation {
        return GetRequiredSignatures(trx, keys: keys).base.toResponse(api.core)
    }
    
    public func getPotentialSignatures<Input>(byTrx trx: Transaction<Input>) -> Single<[Address]> where Input: Operation {
        return GetPotentialSignatures(trx).base.toResponse(api.core)
    }
    
    public func verifyAuthority<Input>(byTrx trx: Transaction<Input>) -> Single<Bool> where Input: Operation {
        return VerifyAuthority(trx).base.toResponse(api.core).catchErrorJustReturn(false)
    }
    
    public func verifyAccountAuthority(byAccount account: String, keys: [Address]) -> Single<Bool> {
        return VerifyAccountAuthority(account, keys: keys).base.toResponse(api.core)
    }
    
    public func validateTransaction<Input>(byTrx trx: Transaction<Input>) -> Single<ProcessedTransaction<Input>> where Input: Operation {
        return ValidateTransaction(trx).base.toResponse(api.core)
    }
    
    public func getFees<Input>(for operations: [Input]) -> Single<[AssetAmount]> where Input: Operation {
        return GetRequiredFees(operations).base.toResponse(api.core)
    }
    
    public func getFee<Input>(for operation: Input) -> Single<AssetAmount> where Input: Operation {
        return getFees(for: [operation]).map({ try $0.first.orThrow(ChainException.network(.notFound)) })
    }
    
    public func getFee(forType type: OperationType) -> Single<AssetAmount> {
        precondition(![
            .proposalCreateOperation,
            .proposalUpdateOperation,
            .withdrawPermissionClaimOperation,
            .customOperation
            ].contains(type), "Not supported operation type")
        return getFee(for: AnyOperation(type))
    }
}

extension ApiProvider: ValidationApi {}
