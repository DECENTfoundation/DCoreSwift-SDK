import Foundation
import RxSwift

protocol CoreRequestConvertible {
    associatedtype Output: Codable
    associatedtype Request: CoreRequestConvertible where Request.Output == Output
    
    var base: Request { get }
    func asCoreRequest(_ core: DCore.Sdk) -> Single<Output>
}

extension CoreRequestConvertible where Request: BaseRequest<Output> {
    func asCoreRequest(_ core: DCore.Sdk) -> Single<Output> {
        return core.make(request: self.base)
    }
}

extension CoreRequestConvertible where Request: WithCallback & BaseRequest<Output>  {
    func asCoreRequest(_ core: DCore.Sdk) -> Single<Output> {
        return core.make(streamRequest: self.base).asSingle()
    }
}

