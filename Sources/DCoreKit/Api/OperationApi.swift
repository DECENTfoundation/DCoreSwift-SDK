import Foundation
import RxSwift

public protocol OperationApi: BaseApi {
    func create(transfer creds: Credentials,
                to: Account.Reference,
                amount: AssetAmount,
                message: String?,
                encrypted: Bool,
                fee: AssetAmount) -> Single<TransferOperation>
    func create(transfer creds: Credentials,
                to: Account.Reference,
                amount: AssetAmount,
                fee: AssetAmount) -> Single<TransferOperation>
    func transfer(_ creds: Credentials,
                  to: Account.Reference,
                  amount: AssetAmount,
                  fee: AssetAmount) -> Observable<TransferConfirmation>
    func transfer(_ creds: Credentials,
                  to: Account.Reference,
                  amount: AssetAmount,
                  message: String?,
                  encrypted: Bool,
                  fee: AssetAmount) -> Observable<TransferConfirmation>
}

extension OperationApi {
    public func create(transfer creds: Credentials,
                       to: Account.Reference,
                       amount: AssetAmount,
                       message: String? = nil,
                       encrypted: Bool = true,
                       fee: AssetAmount = .unset) -> Single<TransferOperation> {
        return api.account.getAccount(byReference: to).map {
            var memo: Memo?
            if let message = message, !encrypted {
                memo = try? Memo(message, keyPair: nil, recipient: nil)
            } else if let message = message {
                memo = try? Memo(message, keyPair: creds.keyPair, recipient: $0.active.keyAuths.first!.value)
            }

            return TransferOperation(from: creds.accountId,
                                     to: $0.id,
                                     amount: amount,
                                     memo: memo,
                                     fee: fee)
        }
    }
    
    public func create(transfer creds: Credentials,
                       to: Account.Reference,
                       amount: AssetAmount,
                       fee: AssetAmount = .unset) -> Single<TransferOperation> {
        return create(transfer: creds, to: to, amount: amount, message: nil, encrypted: false, fee: fee)
    }
    
    public func transfer(_ creds: Credentials,
                         to: Account.Reference,
                         amount: AssetAmount,
                         fee: AssetAmount = .unset) -> Observable<TransferConfirmation> {
        return create(transfer: creds, to: to, amount: amount, fee: fee)
            .asObservable()
            .flatMap { self.api.broadcast.broadcast(withCallback: creds.keyPair, operation: $0) }
    }
    
    public func transfer(_ creds: Credentials,
                         to: Account.Reference,
                         amount: AssetAmount,
                         message: String? = nil,
                         encrypted: Bool = true,
                         fee: AssetAmount = .unset) -> Observable<TransferConfirmation> {
        return create(transfer: creds, to: to, amount: amount, message: message, encrypted: encrypted, fee: fee)
            .asObservable()
            .flatMap { self.api.broadcast.broadcast(withCallback: creds.keyPair, operation: $0) }
    }
}

extension ApiProvider: OperationApi {}
