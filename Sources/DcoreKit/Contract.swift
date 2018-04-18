//
//  Contract.swift
//  DcoreKit
//
//  Created by Michal Grman on 18/04/2018.
//  Copyright © 2018 Decent. All rights reserved.
//

import Foundation
import RxSwift


public protocol Contract {
    
    func getBalance(accountId: ChainObject) -> Single<[AssetAmount]>
    func getAccount(withName name: String) -> Single<Account>
    func getAccount(withId accountId: ChainObject) -> Single<Account>
    
    func search(inAccountHistoryWithId
        accountId: ChainObject,
        order: SearchAccountHistoryOrder,
        from: ChainObject,
        limit: Int
    ) -> Single<[TransactionDetail]>
    
    func search(inPurchasesWithId
        consumerId: ChainObject,
        order: SearchPurchasesOrder,
        from: ChainObject,
        term: String,
        limit: Int
    ) -> Single<[TransactionDetail]>
    
    func getPurchase(withId consumerId: ChainObject) -> Single<Purchase>
    
    func getContent(withId contentId: ChainObject) -> Single<Content>
    func getContent(withUri uri: String) -> Single<Content>
    
    func transfer(usingKeyPair
        keyPair: ECKeyPair,
        from: ChainObject,
        to: ChainObject,
        amount: AssetAmount,
        memo: String?,
        encrypted: Bool
    ) -> Single<TransactionConfirmation>
    
    func transfer(usingCredentials
        credentials: Credentials,
        to: ChainObject,
        amount: AssetAmount,
        memo: String?,
        encrypted: Bool
    ) -> Single<TransactionConfirmation>
    
    func buyContent(using
        content: Content,
        keyPair: ECKeyPair,
        consumer: ChainObject
    ) -> Single<TransactionConfirmation>
    
    func buyContent(usingId
        contentId: ChainObject,
        keyPair: ECKeyPair,
        consumer: ChainObject
    ) -> Single<TransactionConfirmation>
    
    func buyContent(usingUri
        uri: String,
        keyPair: ECKeyPair,
        consumer: ChainObject
    ) -> Single<TransactionConfirmation>
    
    func buyContent(usingCredentials
        credentials: Credentials,
        content: Content
    ) -> Single<TransactionConfirmation>
    
    func getFees(withOperations ops: [BaseOperation]) -> Single<[AssetAmount]>
    func getFees(withOperation op: BaseOperation) -> Single<AssetAmount?>
    
    func voteForMiners(usingKeyPair
        keyPair: ECKeyPair,
        accountId: ChainObject,
        voteIds: Set<String>
    ) -> Single<TransactionConfirmation>
    
    func voteForMiners(usingCredentials
        credentials: Credentials,
        voteIds: Set<String>
    ) -> Single<TransactionConfirmation>
    
    func voteForMiners(usingKeyPair
        keyPair: ECKeyPair,
        accountId: ChainObject,
        minerIds: Set<ChainObject>
    ) -> Single<TransactionConfirmation>
    
    func getMiners(withIds minerIds: Set<ChainObject>) -> Single<[Miner]>
}


extension Contract {
 
    public func transfer(usingCredentials
        credentials: Credentials,
        to: ChainObject,
        amount: AssetAmount,
        memo: String?,
        encrypted: Bool
        ) -> Single<TransactionConfirmation> {
        
        return transfer(usingKeyPair: credentials.keyPair, from: credentials.account, to: to, amount: amount, memo: memo, encrypted: encrypted)
    }
    
    
    public func buyContent(usingId
        contentId: ChainObject,
        keyPair: ECKeyPair,
        consumer: ChainObject
        ) -> Single<TransactionConfirmation> {
        
        return getContent(withId: contentId).flatMap{ self.buyContent(using: $0, keyPair: keyPair, consumer: consumer) }
    }
    
    public func buyContent(usingUri
        uri: String,
        keyPair: ECKeyPair,
        consumer: ChainObject
        ) -> Single<TransactionConfirmation> {
        
        return getContent(withUri: uri).flatMap{ self.buyContent(using: $0, keyPair: keyPair, consumer: consumer) }
    }
    
   public func buyContent(usingCredentials
        credentials: Credentials,
        content: Content
        ) -> Single<TransactionConfirmation> {
        
        return buyContent(using: content, keyPair: credentials.keyPair, consumer: credentials.account)
    }
    
    
    public func getFees(withOperation op: BaseOperation) -> Single<AssetAmount?> {
        return getFees(withOperations: [op]).map{ $0.first }
    }
    
    public func voteForMiners(usingCredentials
        credentials: Credentials,
        voteIds: Set<String>
        ) -> Single<TransactionConfirmation> {
        
        return voteForMiners(usingKeyPair: credentials.keyPair, accountId: credentials.account, voteIds: voteIds)
    }
    
    public func voteForMiners(usingKeyPair
        keyPair: ECKeyPair,
        accountId: ChainObject,
        minerIds: Set<ChainObject>
        ) -> Single<TransactionConfirmation> {
        
        return getMiners(withIds: minerIds).map{ Set($0.map{ $0.voteId }) }.flatMap { self.voteForMiners(usingKeyPair: keyPair, accountId: accountId, voteIds:$0) }
    }
}
