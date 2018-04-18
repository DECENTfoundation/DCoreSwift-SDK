//
//  Dcore.swift
//  DcoreKit
//
//  Created by Michal Grman on 18/04/2018.
//  Copyright © 2018 Decent. All rights reserved.
//

import Foundation
import RxSwift

public class Dcore: Contract {
    
    
    public func getBalance(accountId: ChainObject) -> Single<[AssetAmount]> {
        fatalError("Not implemented")
    }
    
    public func getAccount(withName name: String) -> Single<Account> {
        fatalError("Not implemented")
    }
    
    public func getAccount(withId accountId: ChainObject) -> Single<Account> {
        fatalError("Not implemented")
    }
    
    public func search(inAccountHistoryWithId
        accountId: ChainObject,
        order: SearchAccountHistoryOrder = .TimeDesc,
        from: ChainObject = .None,
        limit: Int = 100
        ) -> Single<[TransactionDetail]> {
        
        fatalError("Not implemented")
    }
    
    public func search(inPurchasesWithId
        consumerId: ChainObject,
        order: SearchPurchasesOrder = .PurchasedDesc,
        from: ChainObject = .None,
        term: String = "",
        limit: Int = 100
        ) -> Single<[TransactionDetail]> {
        
        fatalError("Not implemented")
    }
    
    public func getPurchase(withId consumerId: ChainObject) -> Single<Purchase> {
        fatalError("Not implemented")
    }
    
    public func getContent(withId contentId: ChainObject) -> Single<Content> {
        fatalError("Not implemented")
    }
    
    public func getContent(withUri uri: String) -> Single<Content> {
        fatalError("Not implemented")
    }
    
    public func transfer(usingKeyPair
        keyPair: ECKeyPair,
        from: ChainObject,
        to: ChainObject,
        amount: AssetAmount,
        memo: String? = nil,
        encrypted: Bool = true
        ) -> Single<TransactionConfirmation> {
        
        fatalError("Not implemented")
    }
    
    
    public func buyContent(using
        content: Content,
        keyPair: ECKeyPair,
        consumer: ChainObject
        ) -> Single<TransactionConfirmation> {
     
        fatalError("Not implemented")
    }
    

    public func getFees(withOperations ops: [BaseOperation]) -> Single<[AssetAmount]> {
        fatalError("Not implemented")
    }
    
    public func voteForMiners(usingKeyPair
        keyPair: ECKeyPair,
        accountId: ChainObject,
        voteIds: Set<String>
        ) -> Single<TransactionConfirmation> {
        
        fatalError("Not implemented")
    }
    
    public func getMiners(withIds minerIds: Set<ChainObject>) -> Single<[Miner]> {
        fatalError("Not implemented")
    }
}
