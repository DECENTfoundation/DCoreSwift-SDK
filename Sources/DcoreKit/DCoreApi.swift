import Foundation

extension DCore {
    
    public final class Api {
        
        public var transactionExpiration: Int = 30
        
        public lazy var accountApi = AccountApi(using: self)
        public lazy var assetApi = AssetApi(using: self)
        public lazy var validationApi = ValidationApi(using: self)
        public lazy var balanceApi = BalanceApi(using: self)
        public lazy var blockApi = BlockApi(using: self)
        public lazy var broadcastApi = BroadcastApi(using: self)
        public lazy var contentApi = ContentApi(using: self)
        public lazy var generalApi = GeneralApi(using: self)
        public lazy var historyApi = HistoryApi(using: self)
        public lazy var miningApi = MiningApi(using: self)
        public lazy var purchaseApi = PurchaseApi(using: self)
        public lazy var seedersApi = SeedersApi(using: self)
        public lazy var subscriptionApi = SubscriptionApi(using: self)
        public lazy var transactionApi = TransactionApi(using: self)
        
        let core: Sdk
        
        init(core: Sdk) {
            self.core = core
        }
    }
}
