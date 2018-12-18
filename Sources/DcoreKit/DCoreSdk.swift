import Foundation
import RxSwift

extension DCore {
    
    public class Sdk {
        
        private let client: URLSession
        private var socketUrl: URL? = nil
        private var httpUrl: URL? = nil
        
        private lazy var chainId = GetChainId().toRequest(core: self).cache()
        
        init(socket: URLConvertible? = nil, http: URLConvertible? = nil, client: URLSession? = nil) {
            self.client = client ?? URLSession(configuration: URLSessionConfiguration.default)
            
            if let url = socket { self.socketUrl = url.toURL() }
            if let url = http { self.httpUrl = url.toURL() }
            
            guard self.httpUrl != nil || self.socketUrl != nil else { preconditionFailure("at least one url must be set") }
        }
        
        public static func create(forHttp uri: URLConvertible, client: URLSession? = nil) -> Api {
            return Api(core: Sdk(http: uri, client: client))
        }
        
        public static func create(forWebSocket uri: URLConvertible, client: URLSession? = nil) -> Api {
            return Api(core: Sdk(socket: uri, client: client))
        }
        
        public static func create(forSocketUri uri: URLConvertible, httpUri: URLConvertible, client: URLSession? = nil) -> Api {
            return Api(core: Sdk(socket: uri, http: httpUri, client: client))
        }
        
        func prepareTransaction<T: BaseOperation>(forOperations operations: [T], expiration: Int) -> Single<Transaction> {
            return Single.zip(chainId, GetDynamicGlobalProps().toRequest(core: self)).flatMap({ (id, props) in
                
                // var ops = operations
                // let idx = ops.partition(by: { $0.fee != BaseOperation.FEE_UNSET })
                
                // let noFees = ops[..<idx]
                // first == [30, 10, 20, 30, 30]
                // let fees = ops[idx...]
                // second == [60, 40]
                
                return Single.just(Transaction(blockData: BlockData(props: props, expiration: expiration), operations: operations, chainId: id))
            })
        }
     
        func make<T, R>(requestStream stream: T) -> Observable<T> where T: BaseRequest<R>, T: WithCallback {
            fatalError("bla")
        }
        
        func make<T>(request: BaseRequest<T>) -> Single<T> {
            fatalError("bla")
        }
    }
}
