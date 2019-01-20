import Foundation
import RxSwift

public protocol OperationApi: BaseApi {
    func create(transfer creds: Credentials,
                to: String,
                amount: AssetAmount,
                memo: String?,
                encrypted: Bool,
                fee: AssetAmount) -> Single<TransferOperation>
    func create(transfer creds: Credentials,
                to: String,
                amount: AssetAmount,
                fee: AssetAmount) -> Single<TransferOperation>
    func transfer(_ creds: Credentials,
                  to: String,
                  amount: AssetAmount,
                  fee: AssetAmount) -> Observable<TransferConfirmation>
    func transfer(_ creds: Credentials,
                  to: String,
                  amount: AssetAmount,
                  memo: String?,
                  encrypted: Bool,
                  fee: AssetAmount) -> Observable<TransferConfirmation>
}

extension OperationApi {
    public func create(transfer creds: Credentials,
                       to: String,
                       amount: AssetAmount,
                       memo: String? = nil,
                       encrypted: Bool = true,
                       fee: AssetAmount = .unset) -> Single<TransferOperation> {
        return api.account.getAccount(byReference: to).map {
            
            if memo.isEmptyOrNil() || !encrypted {
                return TransferOperation(from: creds.accountId,
                                         to: $0.id,
                                         amount: amount,
                                         memo: memo.map { Memo($0) },
                                         fee: fee)
            }
            
            let msg = Memo(memo.or(""), keyPair: creds.keyPair, recipient: $0.active.keyAuths.first!.value)
            return TransferOperation(from: creds.accountId,
                                     to: $0.id,
                                     amount: amount,
                                     memo: msg,
                                     fee: fee)
        }
    }
    
    public func create(transfer creds: Credentials,
                       to: String,
                       amount: AssetAmount,
                       fee: AssetAmount = .unset) -> Single<TransferOperation> {
        return create(transfer: creds, to: to, amount: amount, memo: nil, encrypted: false, fee: fee)
    }
    
    public func transfer(_ creds: Credentials,
                         to: String,
                         amount: AssetAmount,
                         fee: AssetAmount = .unset) -> Observable<TransferConfirmation> {
        return create(transfer: creds, to: to, amount: amount, fee: fee)
            .asObservable()
            .flatMap { self.api.broadcast.broadcast(withCallback: creds.keyPair, operation: $0) }
    }
    
    public func transfer(_ creds: Credentials,
                         to: String,
                         amount: AssetAmount,
                         memo: String? = nil,
                         encrypted: Bool = true,
                         fee: AssetAmount = .unset) -> Observable<TransferConfirmation> {
        return create(transfer: creds, to: to, amount: amount, memo: memo, encrypted: encrypted, fee: fee)
            .asObservable()
            .flatMap { self.api.broadcast.broadcast(withCallback: creds.keyPair, operation: $0) }
    }
}

extension ApiProvider: OperationApi {}
