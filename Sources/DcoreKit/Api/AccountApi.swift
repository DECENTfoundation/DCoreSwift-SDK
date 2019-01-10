import Foundation
import RxSwift

public final class AccountApi: BaseApi {
    
    public func getAccount(byName name: String) -> Single<Account> {
        return GetAccountByName(name).asCoreRequest(api.core)
    }
    
    public func getAccounts(byIds ids: [ChainObject]) -> Single<[Account]> {
        return GetAccountById(ids).asCoreRequest(api.core)
    }
    
    public func getAccountIds(byAddressList list: [Address]) -> Single<[[ChainObject]]> {
        return GetKeyReferences(list).asCoreRequest(api.core)
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
                    .flatMap({ [unowned self] result in
                        return self.getAccounts(byIds: result.first!).map({ $0.first! })
                    })
            }
            
            if Account.hasValid(name: value) {
                return self.getAccount(byName: value)
            }
            
            return Single.error(ChainException.unexpected("Value \(value) is not a valid account reference"))
        })
    }
    
    public func search(accountHistory accoundId: ChainObject,
                       from: ChainObject = ObjectType.nullObject.genericId,
                       order: SearchAccountHistoryOrder = .TIME_DESC,
                       limit: Int = 100) -> Single<[TransactionDetail]> {
        return SearchAccountHistory(accountId: accoundId, order: order, startId: from, limit: limit).asCoreRequest(api.core)
    }
    
    public func createCredentials(accountName: String, wif: String) -> Single<Credentials> {
        return self.getAccount(byName: accountName).map({ try Credentials(accountId: $0.id, wif: wif) })
    }
    
    public func getFullAccounts(byNamesOrIds ref: [String], subscribe: Bool = false) -> Single<[String:FullAccount]>{
        return GetFullAccounts(namesOrIds: ref, subscribe: subscribe).asCoreRequest(api.core)
    }
    
    public func getAccountReferences(byId id: ChainObject) -> Single<[ChainObject]> {
        return GetAccountReferences(id).asCoreRequest(api.core)
    }
    
    public func lookupAccount(byNames names: [String]) -> Single<[Account]> {
        return LookupAccountNames(names).asCoreRequest(api.core)
    }
    
    public func lookupAccounts(byLowerBound bound: String, limit: Int = 1000) -> Single<[String:ChainObject]> {
        return LookupAccounts(bound, limit: limit).asCoreRequest(api.core)
    }
    
    public func search(accountsByTerm term: String,
                       order: SearchAccountsOrder = .NAME_DESC,
                       id: ChainObject = ObjectType.nullObject.genericId,
                       limit: Int = 1000) -> Single<[Account]> {
        
        return SearchAccounts(searchTerm: term, order: order, id: id, limit: limit).asCoreRequest(api.core)
    }
    
    public func getAccountCount() -> Single<UInt64> {
        return GetAccountCount().asCoreRequest(api.core)
    }
    
}
