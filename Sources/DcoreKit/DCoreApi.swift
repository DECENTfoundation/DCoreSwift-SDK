import Foundation

extension DCore {
    
    public final class Api {
        
        public var transactionExpiration: Int = DCore.Constant.expiration
        
        public lazy var account: AccountApi =           ApiProvider(using: self)
        public lazy var asset: AssetApi =               ApiProvider(using: self)
        public lazy var validation: ValidationApi =     ApiProvider(using: self)
        public lazy var balance: BalanceApi =           ApiProvider(using: self)
        public lazy var block: BlockApi =               ApiProvider(using: self)
        public lazy var broadcast: BroadcastApi =       ApiProvider(using: self)
        public lazy var operation: OperationApi =       ApiProvider(using: self)
        public lazy var content: ContentApi =           ApiProvider(using: self)
        public lazy var general: GeneralApi =           ApiProvider(using: self)
        public lazy var history: HistoryApi =           ApiProvider(using: self)
        public lazy var mining: MiningApi =             ApiProvider(using: self)
        public lazy var purchase: PurchaseApi =         ApiProvider(using: self)
        public lazy var seeders: SeedersApi =           ApiProvider(using: self)
        public lazy var subscription: SubscriptionApi = ApiProvider(using: self)
        public lazy var transaction: TransactionApi =   ApiProvider(using: self)
        
        let core: Sdk
        
        required init(core: Sdk) {
            self.core = core
        }
    }
}
