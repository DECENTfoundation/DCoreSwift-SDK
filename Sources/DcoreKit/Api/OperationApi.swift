import Foundation
import RxSwift

public final class OperationApi: BaseApi {
    
    public func create(transfer creds: Credentials,
                       to: String, amount: AssetAmount,
                       message: String? = nil,
                       encrypted: Bool = true,
                       fee: AssetAmount? = nil) -> Single<TransferOperation> {
        return api.account.getAccount(byReference: to).map {
            
            guard !(message ?? "").isEmpty && encrypted else {
                return TransferOperation(from: creds.accountId,
                                         to: $0.id,
                                         amount: amount,
                                         memo: Memo(message ?? ""),
                                         fee: fee ?? BaseOperation.feeUnset)
            }
            
            let memo = Memo(message!, keyPair: creds.keyPair, recipient: $0.active.keyAuths.first!.value)
            return TransferOperation(from: creds.accountId,
                                     to: $0.id,
                                     amount: amount,
                                     memo: memo,
                                     fee: fee ?? BaseOperation.feeUnset)
        }
    }
    
    public func create(transfer creds: Credentials,
                       to: String,
                       amount: AssetAmount,
                       fee: AssetAmount? = nil) -> Single<TransferOperation> {
        return create(transfer: creds, to: to, amount: amount, message: nil, encrypted: false, fee: fee)
    }
    
    public func transfer(_ creds: Credentials,
                         to: String,
                         amount: AssetAmount,
                         fee: AssetAmount? = nil) -> Observable<TransactionConfirmation> {
        return create(transfer: creds, to: to, amount: amount, fee: fee)
            .asObservable()
            .flatMap { [unowned self] in self.api.broadcast.broadcast(withCallback: creds.keyPair, operation: $0) }
    }
    
    public func transfer(_ creds: Credentials,
                         to: String,
                         amount: AssetAmount,
                         message: String? = nil,
                         encrypted: Bool = true,
                         fee: AssetAmount? = nil) -> Observable<TransactionConfirmation> {
        return create(transfer: creds, to: to, amount: amount, message: message, encrypted: encrypted, fee: fee)
            .asObservable()
            .flatMap { [unowned self] in self.api.broadcast.broadcast(withCallback: creds.keyPair, operation: $0) }
    }
}
