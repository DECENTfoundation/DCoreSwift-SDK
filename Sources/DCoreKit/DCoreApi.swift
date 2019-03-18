import Foundation

extension DCore {
    
    open class Api: SecurityConfigurable, SecurityExtensionProvider {
        
        var transactionExpiration: Int = DCore.Constant.expiration
        
        public lazy var account: AccountApi =           ApiProvider(using: self)
        public lazy var asset: AssetApi =               ApiProvider(using: self)
        public lazy var validation: ValidationApi =     ApiProvider(using: self)
        public lazy var balance: BalanceApi =           ApiProvider(using: self)
        public lazy var block: BlockApi =               ApiProvider(using: self)
        public lazy var broadcast: BroadcastApi =       ApiProvider(using: self)
        public lazy var content: ContentApi =           ApiProvider(using: self)
        public lazy var general: GeneralApi =           ApiProvider(using: self)
        public lazy var history: HistoryApi =           ApiProvider(using: self)
        public lazy var mining: MiningApi =             ApiProvider(using: self)
        public lazy var purchase: PurchaseApi =         ApiProvider(using: self)
        public lazy var seeders: SeedersApi =           ApiProvider(using: self)
        public lazy var subscription: SubscriptionApi = ApiProvider(using: self)
        public lazy var transaction: TransactionApi =   ApiProvider(using: self)
        
        let core: Sdk
        
        required public init(core: Sdk) {
            self.core = core
        }
        
        func secured(by validator: ServerTrustValidation?) {
            core.secured(by: validator)
        }
    }
}

extension SecurityExtension where Base: DCore.Api {
    
    @discardableResult
    public func trusted(by validator: ServerTrustValidation?) -> Base {
        base.secured(by: validator)
        return base
    }
}
