import Foundation
import RxSwift

public final class AccountApi: BaseApi {
    
    public func getAccount(byName name: String) -> Single<Account> {
        return GetAccountByName(name).toRequest(core: api.core)
    }
    
    public func getAccounts(byIds ids: [ChainObject]) -> Single<[Account]> {
        return GetAccountById(ids).toRequest(core: api.core)
    }
    
    public func getAccountIds(byAddressList list: [Address]) -> Single<[[ChainObject]]> {
        return GetKeyReferences(list).toRequest(core: api.core)
    }
    
    public func existAccount(byName name: String) -> Single<Bool> {
        return getAccount(byName: name).map({ _ in true }).catchErrorJustReturn(false)
    }
    
    public func getAccount(byReference value: Account.Reference) -> Single<Account> {
        return Single.deferred({ [unowned self] in
            
            if let object = try? ChainObject(from: value) {
                return self.getAccounts(byIds: [object]).map({ $0.first! })
            }
            
            if let address = try? Address(from: value) {
                return self.getAccountIds(byAddressList: [address])
                    .map({ $0.first! })
                    .flatMap({ [unowned self] ids in
                        return self.getAccounts(byIds: ids).map({ $0.first! })
                    })
            }
            
            if Account.hasValid(name: value) {
                return self.getAccount(byName: value)
            }
            
            return Single.error(DCoreError.illegal("\(value) is not a valid account reference"))
        })
    }
    
    public func search(accountHistory accoundId: ChainObject,
                       from: ChainObject = ObjectType.nullObject.genericId,
                       order: SearchAccountHistoryOrder = .TIME_DESC,
                       limit: Int = 100) -> Single<[TransactionDetail]> {
        return SearchAccountHistory(accountId: accoundId, order: order, startId: from, limit: limit).toRequest(core: api.core)
    }
    
    public func createCredentials(accountName: String, wif: String) -> Single<Credentials> {
        return self.getAccount(byName: accountName).map({ try Credentials(accountId: $0.id, wif: wif) })
    }
    
    public func getFullAccounts(byNamesOrIds ref: [String], subscribe: Bool = false) -> Single<[String:FullAccount]>{
        return GetFullAccounts(namesOrIds: ref, subscribe: subscribe).toRequest(core: api.core)
    }
    
    public func getAccountReferences(byId id: ChainObject) -> Single<[ChainObject]> {
        return GetAccountReferences(id).toRequest(core: api.core)
    }
    
    public func lookupAccount(byNames names: [String]) -> Single<[Account]> {
        return LookupAccountNames(names).toRequest(core: api.core)
    }
    
    public func lookupAccounts(byLowerBound bound: String, limit: Int = 1000) -> Single<[String:ChainObject]> {
        return LookupAccounts(bound, limit: limit).toRequest(core: api.core)
    }
    
    public func search(accountsByTerm term: String,
                       order: SearchAccountsOrder = .NAME_DESC,
                       id: ChainObject = ObjectType.nullObject.genericId,
                       limit: Int = 1000) -> Single<[Account]> {
        
        return SearchAccounts(searchTerm: term, order: order, id: id, limit: limit).toRequest(core: api.core)
    }
    
    public func getAccountCount() -> Single<UInt64> {
        return GetAccountCount().toRequest(core: api.core)
    }
    
}
