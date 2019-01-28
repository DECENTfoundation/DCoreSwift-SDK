import Foundation
import RxSwift

extension DCore {
    
    open class Sdk {
        
        private var rest: RestService?
        private var wss: WssService?
        
        private lazy var chainId = GetChainId().base.toResponse(self).cache()
        
        public required init(wssUri: URLConvertible? = nil,
                             restUri: URLConvertible? = nil,
                             session: URLSession? = nil) {
        
            if let path = restUri, let url = path.asURL() { rest = RestService(url, session: session) }
            if let path = wssUri, let url = path.asURL() { wss = WssService(url, timeout: Constant.timeout) }
            
            precondition(rest != nil || wss != nil, "At least one uri have to be set correctly")
        }
        
        public static func create(forRest uri: URLConvertible, session: URLSession? = nil) -> Api {
            return Api(core: Sdk(restUri: uri, session: session))
        }
        
        public static func create(forWss uri: URLConvertible) -> Api {
            return Api(core: Sdk(wssUri: uri))
        }
        
        public static func create(forWss uri: URLConvertible,
                                  andRest restUri: URLConvertible,
                                  session: URLSession? = nil) -> Api {
            return Api(core: Sdk(wssUri: uri, restUri: restUri, session: session))
        }
        
        func prepare<Input>(transactionUsing operations: [Input],
                            expiration: Int) -> Single<Transaction<Input>> where Input: Operation {
            return Single.deferred { [unowned self] in
                let (fees, noFees) = operations.partitionSplit(by: { $0.fee != .unset })
                return Single.zip(self.chainId, GetDynamicGlobalProps().base.toResponse(self), (
                    noFees.isEmpty ? Single.just(fees) : GetRequiredFees(noFees).base.toResponse(self).map { req in
                        return noFees.enumerated().map { offset, op in
                            return op.apply(fee: req[offset])
                        } + fees
                    }
                )).flatMap { id, props, ops in
                    let block = BlockData(props: props, expiration: expiration)
                    return Single.just(
                        Transaction(block, operations: ops, chainId: id)
                    )
                }
            }
        }
     
        func make<Output>(streamRequest req: BaseRequest<Output>) -> Observable<Output> where Output: Codable {
            guard let wss = wss, req.callback else {
                return Observable.error(
                    DCoreException.unexpected("Only callbacks calls available through wss stream api")
                )
            }
            return wss.request(usingStream: req)
        }
        
        func make<Output>(request req: BaseRequest<Output>) -> Single<Output> where Output: Codable {
            if let wss = wss, rest == nil || req.callback {
                return wss.request(using: req)
            } else {
                guard let rest = rest, !req.callback else {
                    return Single.error(
                        DCoreException.unexpected("Calls with callbacks are not available through rest api")
                    )
                }
                return rest.request(using: req)
            }
        }
    }
}
