import Foundation
import RxSwift

protocol ChainRequestConvertible {
    associatedtype Output: Codable
    associatedtype Request: ChainRequestConvertible where Request.Output == Output
    
    var base: Request { get }
    func asChainRequest(_ chain: DCore.Sdk) -> Single<Output>
}

extension ChainRequestConvertible where Request == BaseRequest<Output> {
    func asChainRequest(_ chain: DCore.Sdk) -> Single<Output> {
        guard self.base.callback else { return chain.make(request: self.base) }
        return chain.make(streamRequest: self.base).asSingle()
    }
}

