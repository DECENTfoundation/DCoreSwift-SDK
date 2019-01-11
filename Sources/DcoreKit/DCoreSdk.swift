import Foundation
import RxSwift
import os.log

extension DCore {
    
    public final class Sdk {
        
        private var rest: RestService? = nil
        private var wss: WssService? = nil
        private lazy var chainId = GetChainId().base.asChainRequest(self).cache()
        
        internal required init(wssUri: URLConvertible? = nil, restUri: URLConvertible? = nil, session: URLSession? = nil) {
        
            if let path = restUri, let url = path.asURL() { rest = RestService(url, session: session) }
            if let path = wssUri, let url = path.asURL() { wss = WssService(url) }
            
            precondition(rest != nil || wss != nil , "At least one uri have to be set correctly")
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
            return Single.zip(chainId, GetDynamicGlobalProps().base.asChainRequest(self)).flatMap({ (id, props) in
                
                // var ops = operations
                // let idx = ops.partition(by: { $0.fee != BaseOperation.FEE_UNSET })
                
                // let noFees = ops[..<idx]
                // first == [30, 10, 20, 30, 30]
                // let fees = ops[idx...]
                // second == [60, 40]
                
                return Single.just(Transaction(blockData: BlockData(props: props, expiration: expiration), operations: operations, chainId: id))
            })
        }
     
        func make<Output>(streamRequest req: BaseRequest<Output>) -> Observable<Output> where Output: Codable {
            guard let wss = wss, req.callback else { return Observable.error(ChainException.unexpected("Only callbacks calls available through wss stream api")) }
            return wss.request(usingStream: req)
        }
        
        func make<Output>(request req: BaseRequest<Output>) -> Single<Output> where Output: Codable {
            if let wss = wss, rest == nil || req.callback {
                return wss.request(using: req)
            } else {
                guard let rest = rest, !req.callback else {
                    return Single.error(ChainException.unexpected("Calls with callbacks are not available through rest api"))
                }
                return rest.request(using: req)
            }
        }
    }
}
