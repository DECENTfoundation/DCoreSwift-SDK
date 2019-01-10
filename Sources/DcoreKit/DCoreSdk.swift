import Foundation
import RxSwift

extension DCore {
    
    public final class Sdk {
        
        private var rest: RestService? = nil
        private var wss: WssService? = nil
        private var logger: LoggerConvertible? = nil
        
        private lazy var chainId = GetChainId().asCoreRequest(self).cache()
        
        internal required init(wssUri: URLConvertible? = nil, restUri: URLConvertible? = nil, session: URLSession? = nil, logger: LoggerConvertible? = nil) {
            self.logger = logger
            
            if let path = restUri, let url = path.asURL() { rest = RestService(url, session: session) }
            if let path = wssUri, let url = path.asURL() { wss = WssService(url) }
            
            guard rest != nil || wss != nil else { preconditionFailure("At least one uri have to be set correctly") }
        }
        
        public static func create(forRest uri: URLConvertible, session: URLSession? = nil) -> Api {
            return Api(core: Sdk(restUri: uri, session: session))
        }
        
        public static func create(forWss uri: URLConvertible) -> Api {
            return Api(core: Sdk(wssUri: uri))
        }
        
        public static func create(forWss uri: URLConvertible, andRest restUri: URLConvertible, session: URLSession? = nil) -> Api {
            return Api(core: Sdk(wssUri: uri, restUri: restUri, session: session))
        }
        
        func prepareTransaction<Operation>(forOperations operations: [Operation], expiration: Int) -> Single<Transaction> where Operation: BaseOperation {
            return Single.zip(chainId, GetDynamicGlobalProps().asCoreRequest(self)).flatMap({ (id, props) in
                
                // var ops = operations
                // let idx = ops.partition(by: { $0.fee != BaseOperation.FEE_UNSET })
                
                // let noFees = ops[..<idx]
                // first == [30, 10, 20, 30, 30]
                // let fees = ops[idx...]
                // second == [60, 40]
                
                return Single.just(Transaction(blockData: BlockData(props: props, expiration: expiration), operations: operations, chainId: id))
            })
        }
     
        func make<Output>(request: BaseRequest<Output>) -> Single<Output> where Output: Codable {
            if let wss = wss, rest == nil || (request is WithCallback) {
                return wss.request(using: request)
            } else {
                guard let rest = rest, !(request is WithCallback) else {
                    return Single.error(ChainException.unexpected("Callbacks are not available through rest api"))
                }
                return rest.request(using: request)
            }
        }
    }
}
