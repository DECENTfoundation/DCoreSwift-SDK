import Foundation

extension DCore {
    
    public final class Api {
        
        public var transactionExpiration: Int = DCore.Constant.expiration
        
        public lazy var account = AccountApi(using: self)
        public lazy var asset = AssetApi(using: self)
        public lazy var validation = ValidationApi(using: self)
        public lazy var balance = BalanceApi(using: self)
        public lazy var block = BlockApi(using: self)
        public lazy var broadcast = BroadcastApi(using: self)
        public lazy var operation = OperationApi(using: self)
        public lazy var content = ContentApi(using: self)
        public lazy var general = GeneralApi(using: self)
        public lazy var history = HistoryApi(using: self)
        public lazy var mining = MiningApi(using: self)
        public lazy var purchase = PurchaseApi(using: self)
        public lazy var seeders = SeedersApi(using: self)
        public lazy var subscription = SubscriptionApi(using: self)
        public lazy var transaction = TransactionApi(using: self)
        
        let core: Sdk
        
        required init(core: Sdk) {
            self.core = core
        }
    }
}
