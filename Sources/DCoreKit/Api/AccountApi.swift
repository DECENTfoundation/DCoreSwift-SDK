import Foundation
import RxSwift

public protocol AccountApi: BaseApi {
    
    /**
     Check if the account exist.
     
     - Parameter name: Account name.
     
     - Returns: `true` if account exist.
     */
    func exist(byName name: String) -> Single<Bool>
    
    /**
     Check if the account exist.
     
     - Parameter id: Account id as `ChainObject` or `String` format.
     
     - Returns: `true` if account exist.
     */
    func exist(byId id: ChainObjectConvertible) -> Single<Bool>
    
    /**
     Check if the account exist.
     
     - Parameter ref: Account id or name.
     
     - Returns: `true` if account exist.
     */
    func exist(byReference ref: Account.Reference) -> Single<Bool>
    
    /**
     Get account by name.
     
     - Parameter name: Account name.
     
     - Throws: `DCoreException.Network.notFound`
     if account does not exist.
 
     - Returns: An `Account` if exist.
     */
    func get(byName name: String) -> Single<Account>
    
    /**
     Get account by id.
     
     - Parameter id: Account id as `ChainObject` or `String` format.
     
     - Throws: `DCoreException.Network.notFound`
     if account does not exist.
     
     - Returns: An `Account` if exist.
     */
    func get(byId id: ChainObjectConvertible) -> Single<Account>
    
    /**
     Get account by reference (id or name) in `String` format.
     
     - Parameter ref: Account id or name.
     
     - Throws: `DCoreException.Network.notFound`
     if account does not exist.
     
     - Returns: An `Account` if exist.
     */
    func get(byReference ref: Account.Reference) -> Single<Account>
    
    /**
     Get accounts by ids.
     
     - Parameter ids: Account ids as `ChainObject` or `String` format.

     - Returns: An `[Account]` array.
     */
    func getAll(byIds ids: [ChainObjectConvertible]) -> Single<[Account]>
    
    /**
     Get accounts by names.
     
     - Parameter names: Account names.
     
     - Returns: An `[Account]` array.
     */
    func getAll(byNames names: [String]) -> Single<[Account]>
    
    /**
     Get all objects relevant to the specified accounts and subscribe to updates.
     
     - Parameter refs: Account references (id or name) in `String` format.
     - Parameter subscribe: `true` to subscribe to updates, default `false`.
     
     - Returns: Map `[String: FullAccount]` of names or ids to account, or empty map if not present.
     */
    func getFullAccounts(byReferences refs: [Account.Reference], subscribe: Bool) -> Single<[String: FullAccount]>
  
    /**
     Get accounts ids by public key addresses.
     
     - Parameter keys: Formatted public keys of the account,
     eg. DCT5j2bMj7XVWLxUW7AXeMiYPambYFZfCcMroXDvbCfX1VoswcZG4.
     
     - Returns: All `[[ChainObject]]` account references by given keys.
     */
    func findAllReferences(byKeys keys: [Address]) -> Single<[[ChainObject]]>
    
    /**
     Get all accounts that refer to the account id in their owner or active authorities.
     
     - Parameter id: Account id.
     
     - Returns: All `[[ChainObject]]` account references by given keys.
     */
    func findAllReferences(byId id: ChainObject) -> Single<[ChainObject]>

    /**
     Get names and ids for registered accounts.
     
     - Parameter lowerBound: Bound of the first name to return.
     - Parameter limit: Number of items to get, max/default `1000`
     
     - Returns: Map `[String: ChainObject]` of account names to corresponding ids.
     */
    func findAllRelative(byLowerBound lowerBound: String, limit: Int) -> Single<[String: ChainObject]>
    
    /**
     Get accounts that match lookup expression.
     
     - Parameter expression: Will try to partially match account name or id.
     - Parameter order: Sort data by field, default `SearchOrder.Accounts.nameDesc`.
     - Parameter id: Object id to start searching from, default `0.0.0`.
     - Parameter limit: Number of items to get, max/default `1000`.
     
     - Returns: Map `[String: ChainObject]` of account names to corresponding ids.
     */
    func findAll(by expression: String,
                 order: SearchOrder.Accounts,
                 id: ChainObject,
                 limit: Int) -> Single<[Account]>
    
    /**
     Get the total number of registered accounts.
     
     - Returns: Number of registered accounts.
     */
    func countAll() -> Single<UInt64>

    /**
     Create account credentails by account name.
     
     - Parameter name: Account name.
     - Parameter wif: Private key in wif base58 format,
     eg. 5Jd7zdvxXYNdUfnEXt5XokrE3zwJSs734yQ36a1YaqioRTGGLtn.
     
     - Throws: `DCoreException.Network.notFound`
     if account does not exist.
     
     - Returns: Account `Credentials`.
     */
    func createCredentials(byName name: String, wif: String) -> Single<Credentials>
    
    /**
     Create account credentails by account name.
     
     - Parameter name: Account name.
     - Parameter wif: Private key in AES encrypted format.
     - Parameter passphrase: Keypass to unlock encrypted private key.
     
     - Throws: `DCoreException.Network.notFound`
     if account does not exist.
     
     - Returns: Account `Credentials`.
     */
    func createCredentials(byName name: String, encryptedWif wif: String, passphrase: String) -> Single<Credentials>
    
    /**
     Create account.
     
     - Parameter account: SubmitAccount object with name and public key (Address).
     - Parameter registrar: Credentials of account which will pay operation fee.
     - Parameter fee: `AssetAmount` fee for the operation,
     if left `AssetAmount.unset` the fee will be computed in DCT asset,
     default `AssetAmount.unset`.
     
     - Throws: `DCoreException.Network.alreadyFound`
     if account with given name already exist.
     
     - Returns: `TransactionConfirmation` that account was created.
     */
    func create(_ account: SubmitAccount, registrar: Credentials, fee: AssetAmount) -> Single<TransactionConfirmation>
    
    /**
     Create transfer operation between two accounts using credentails.
     
     - Parameter credentails: Sender account credentials.
     - Parameter to: Receiver account reference.
     - Parameter amount: `AssetAmount` to send with asset type.
     - Parameter message: Message (Optional).
     - Parameter encrypted: If message present,
     encrypted is visible only for sender and receiver,
     unencrypted is visible publicly, default `true`.
     - Parameter fee: `AssetAmount` fee for the operation,
     if left `AssetAmount.unset` the fee will be computed in DCT asset,
     default `AssetAmount.unset`.
     
     - Returns: `TransferOperation`.
     */
    func createTransfer(from credentials: Credentials,
                        to: Account.Reference,
                        amount: AssetAmount,
                        message: String?,
                        encrypted: Bool,
                        fee: AssetAmount) -> Single<TransferOperation>
    
    /**
     Create transfer operation between two accounts using credentails.
     
     - Parameter credentails: Sender account credentials.
     - Parameter to: Receiver account reference.
     - Parameter amount: `AssetAmount` to send with asset type.
     - Parameter fee: `AssetAmount` fee for the operation,
     if left `AssetAmount.unset` the fee will be computed in DCT asset,
     default `AssetAmount.unset`.
     
     - Returns: `TransferOperation`.
     */
    func createTransfer(from credentials: Credentials,
                        to: Account.Reference,
                        amount: AssetAmount,
                        fee: AssetAmount) -> Single<TransferOperation>

    /**
     Make a transfer between two accounts
     
     - Parameter credentails: Sender account credentials.
     - Parameter to: Receiver account reference.
     - Parameter amount: `AssetAmount` to send with asset type.
     - Parameter message: Message (Optional).
     - Parameter encrypted: If message present,
     encrypted is visible only for sender and receiver,
     unencrypted is visible publicly, default `true`.
     - Parameter fee: `AssetAmount` fee for the operation,
     if left `AssetAmount.unset` the fee will be computed in DCT asset,
     default `AssetAmount.unset`.
     
     - Returns: A transaction confirmation.
     */
    func transfer(from credentials: Credentials,
                  to: Account.Reference,
                  amount: AssetAmount,
                  message: String?,
                  encrypted: Bool,
                  fee: AssetAmount) -> Single<TransactionConfirmation>
    
    /**
     Make a transfer between two accounts
     
     - Parameter credentails: Sender account credentials.
     - Parameter to: Receiver account reference.
     - Parameter amount: `AssetAmount` to send with asset type.
     - Parameter fee: `AssetAmount` fee for the operation,
     if left `AssetAmount.unset` the fee will be computed in DCT asset,
     default `AssetAmount.unset`.
     
     - Returns: A transaction confirmation.
     */
    func transfer(from credentials: Credentials,
                  to: Account.Reference,
                  amount: AssetAmount,
                  fee: AssetAmount) -> Single<TransactionConfirmation>
}

extension AccountApi {
    public func exist(byName name: String) -> Single<Bool> {
        return get(byName: name).map({ _ in true }).catchErrorJustReturn(false)
    }
    
    public func exist(byId id: ChainObjectConvertible) -> Single<Bool> {
        return get(byId: id).map({ _ in true }).catchErrorJustReturn(false)
    }
    
    public func exist(byReference ref: Account.Reference) -> Single<Bool> {
        return get(byReference: ref).map({ _ in true }).catchErrorJustReturn(false)
    }
    
    public func get(byName name: String) -> Single<Account> {
        return GetAccountByName(name).base.toResponse(api.core)
    }
    
    public func get(byId id: ChainObjectConvertible) -> Single<Account> {
        return getAll(byIds: [id]).map {
            try $0.first.orThrow(DCoreException.network(.notFound))
        }
    }
    
    public func get(byReference ref: Account.Reference) -> Single<Account> {
        return Single.deferred {
            if let id = ref.dcore.chainObject {
                return self.get(byId: id)
            }
            if Account.hasValid(name: ref) {
                return self.get(byName: ref)
            }
            return Single.error(DCoreException.unexpected("Value \(ref) is not a valid account reference"))
        }
    }
    
    public func getAll(byIds ids: [ChainObjectConvertible]) -> Single<[Account]> {
        return Single.deferred {
            return GetAccountById(try ids.map { try $0.asChainObject() }).base.toResponse(self.api.core)
        }
    }
    
    public func getAll(byNames names: [String]) -> Single<[Account]> {
        return LookupAccountNames(names).base.toResponse(api.core)
    }
    
    public func getFullAccounts(byReferences refs: [Account.Reference], subscribe: Bool = false) -> Single<[String: FullAccount]> {
        return GetFullAccounts(refs, subscribe: subscribe).base.toResponse(api.core)
    }
    
    public func findAllReferences(byKeys keys: [Address]) -> Single<[[ChainObject]]> {
        return GetKeyReferences(keys).base.toResponse(api.core)
    }
    
    public func findAllReferences(byId id: ChainObject) -> Single<[ChainObject]> {
        return GetAccountReferences(id).base.toResponse(api.core)
    }
    
    public func findAllRelative(byLowerBound bound: String, limit: Int = 1000) -> Single<[String: ChainObject]> {
        return LookupAccounts(bound, limit: limit).base.toResponse(api.core)
    }
    
    public func findAll(by expression: String,
                        order: SearchOrder.Accounts = .nameDesc,
                        id: ChainObject = ObjectType.nullObject.genericId,
                        limit: Int = 1000) -> Single<[Account]> {
        
        return SearchAccounts(expression, order: order, id: id, limit: limit).base.toResponse(api.core)
    }
    
    public func countAll() -> Single<UInt64> {
        return GetAccountCount().base.toResponse(api.core)
    }
    
    public func createCredentials(byName name: String, wif: String) -> Single<Credentials> {
        return self.get(byName: name).map({ try Credentials($0.id, wif: wif) })
    }
    
    public func createCredentials(byName name: String, encryptedWif wif: String, passphrase: String) -> Single<Credentials> {
        return self.get(byName: name).map({ try Credentials($0.id, encryptedWif: wif, passphrase: passphrase) })
    }
    
    public func create(_ account: SubmitAccount, registrar: Credentials, fee: AssetAmount = .unset) -> Single<TransactionConfirmation> {
        return exist(byName: account.name).flatMap { result in
            guard !result else { return Single.error(DCoreException.network(.alreadyFound)) }
            return self.api.broadcast.broadcast(withCallback: registrar.keyPair, operation: AccountCreateOperation(
                account, registrar: registrar.accountId, fee: fee
                )
            )
        }
    }
    
    public func createTransfer(from credentials: Credentials,
                               to: Account.Reference,
                               amount: AssetAmount,
                               message: String? = nil,
                               encrypted: Bool = true,
                               fee: AssetAmount = .unset) -> Single<TransferOperation> {
        return api.account.get(byReference: to).map {
            var memo: Memo?
            if let message = message, !encrypted {
                memo = try? Memo(message, keyPair: nil, recipient: nil)
            } else if let message = message {
                memo = try? Memo(message, keyPair: credentials.keyPair, recipient: $0.active.keyAuths.first!.value)
            }
            
            return TransferOperation(from: credentials.accountId,
                                     to: $0.id,
                                     amount: amount,
                                     memo: memo,
                                     fee: fee)
        }
    }
    
    public func createTransfer(from credentials: Credentials,
                               to: Account.Reference,
                               amount: AssetAmount,
                               fee: AssetAmount = .unset) -> Single<TransferOperation> {
        return createTransfer(from: credentials, to: to, amount: amount, message: nil, encrypted: false, fee: fee)
    }
    
    public func transfer(from credentials: Credentials,
                         to: Account.Reference,
                         amount: AssetAmount,
                         message: String? = nil,
                         encrypted: Bool = true,
                         fee: AssetAmount = .unset) -> Single<TransactionConfirmation> {
        return createTransfer(from: credentials, to: to, amount: amount, message: message, encrypted: encrypted, fee: fee)
            .flatMap { self.api.broadcast.broadcast(withCallback: credentials.keyPair, operation: $0) }
    }
    
    public func transfer(from credentials: Credentials,
                         to: Account.Reference,
                         amount: AssetAmount,
                         fee: AssetAmount = .unset) -> Single<TransactionConfirmation> {
        return createTransfer(from: credentials, to: to, amount: amount, fee: fee)
            .flatMap { self.api.broadcast.broadcast(withCallback: credentials.keyPair, operation: $0) }
    }
}

extension ApiProvider: AccountApi {}
