import Foundation
import RxSwift

public class AccountApi: BaseApi {
    
    public func getAccount(byName name: String) -> Single<Account> {
        return GetAccountByName(name: name).toRequest(core: self.api.core)
    }
    
    public func getAccounts(byIds ids: [ChainObject]) -> Single<[Account]> {
        return GetAccountById(accountIds: ids).toRequest(core: self.api.core)
    }
    
    public func getAccountIds(byAddresses addresses: [Address]) -> Single<[[ChainObject]]> {
        return GetKeyReferences(address: addresses).toRequest(core: self.api.core)
    }
    
    public func existAccount(byName name: String) -> Single<Bool> {
        return getAccount(byName: name).map({ _ in return true }).catchErrorJustReturn(false)
    }
    
    public func getAccount(byReference reference: String) -> Single<Account> {
        return Single.deferred({ [unowned self] in
            switch true {
            case ChainObject.isValid(usingObjectId: reference):
                return self.getAccounts(byIds: [reference.toChainObject()]).map({ $0.first! })
            case Address.isValid(using: reference):
                return self.getAccountIds(byAddresses: [try! Address.decode(from: reference)])
                    .map({ $0.first! })
                    .flatMap({ [unowned self] ids in
                        return self.getAccounts(byIds: ids).map({ $0.first! })
                    })
            case Account.isValid(with: reference):
                return self.getAccount(byName: reference)
            default:
                return Single.error(ChainError.illegal("not a valid account reference"))
            }
        })
    }
    
    public func search(accountHistory accoundId: ChainObject,
                       from: ChainObject = ObjectType.NULL_OBJECT.genericId,
                       order: SearchAccountHistoryOrder = .TIME_DESC,
                       limit: Int = 100) -> Single<[TransactionDetail]> {
        return SearchAccountHistory(accountId: accoundId, order: order, startId: from, limit: limit).toRequest(core: self.api.core)
    }
    
    public func createCredentials(account: String, privateKey: String) -> Single<Credentials> {
        return self.getAccount(byName: account).map({ Credentials(account: $0.id, encodedPrivateKey: privateKey) })
    }
    
    public func getFullAccounts(byNamesOrIds ref: [String], subscribe: Bool = false) -> Single<[String:FullAccount]>{
        return GetFullAccounts(namesOrIds: ref, subscribe: subscribe).toRequest(core: self.api.core)
    }
    
    public func getAccountReferences(accountId: ChainObject) -> Single<[ChainObject]> {
        return GetAccountReferences(accountId: accountId).toRequest(core: self.api.core)
    }
    
    public func lookupAccountNames(names: [String]) -> Single<[Account]> {
        return LookupAccountNames(names: names).toRequest(core: self.api.core)
    }
    
    public func lookupAccounts(lowerBound: String, limit: Int = 1000) -> Single<[String:ChainObject]> {
        return LookupAccounts(lowerBound: lowerBound, limit: limit).toRequest(core: self.api.core)
    }
    
    public func search(accountsByTerm term: String,
                       order: SearchAccountsOrder = .NAME_DESC,
                       id: ChainObject = ObjectType.NULL_OBJECT.genericId,
                       limit: Int = 1000) -> Single<[Account]> {
        
        return SearchAccounts(searchTerm: term, order: order, id: id, limit: limit).toRequest(core: self.api.core)
    }
    
    public func getAccountCount() -> Single<UInt64> {
        return GetAccountCount().toRequest(core: self.api.core)
    }
    
}
