import Foundation
import RxSwift

extension DCore {
    
    public final class Sdk {
        
        private var rpc: RpcService? = nil
        private var wss: WssService? = nil
        private var logger: LoggerConvertible? = nil
        
        private lazy var chainId = GetChainId().toCoreRequest(self).cache()
        
        required init(socket: URLConvertible? = nil, http: URLConvertible? = nil, session: URLSession? = nil, logger: LoggerConvertible? = nil) {
            self.logger = logger
            
            if let path = socket, let url = path.toURL() { self.rpc = RpcService(url, session: session) }
            if let path = http, let url = path.toURL() { self.wss = WssService(url) }
            
            guard self.rpc != nil || self.wss != nil else { preconditionFailure("At least one uri have to be set correctly") }
        }
        
        public static func create(forHttp uri: URLConvertible, session: URLSession? = nil) -> Api {
            return Api(core: Sdk(http: uri, session: session))
        }
        
        public static func create(forWebSocket uri: URLConvertible) -> Api {
            return Api(core: Sdk(socket: uri))
        }
        
        public static func create(forSocketUri uri: URLConvertible, httpUri: URLConvertible, session: URLSession? = nil) -> Api {
            return Api(core: Sdk(socket: uri, http: httpUri, session: session))
        }
        
        func prepareTransaction<T: BaseOperation>(forOperations operations: [T], expiration: Int) -> Single<Transaction> {
            return Single.zip(chainId, GetDynamicGlobalProps().toCoreRequest(self)).flatMap({ (id, props) in
                
                // var ops = operations
                // let idx = ops.partition(by: { $0.fee != BaseOperation.FEE_UNSET })
                
                // let noFees = ops[..<idx]
                // first == [30, 10, 20, 30, 30]
                // let fees = ops[idx...]
                // second == [60, 40]
                
                return Single.just(Transaction(blockData: BlockData(props: props, expiration: expiration), operations: operations, chainId: id))
            })
        }
     
        func make<T: Codable>(request: BaseRequest<T>) -> Single<T> {
            fatalError("bla")
        }
    }
}
