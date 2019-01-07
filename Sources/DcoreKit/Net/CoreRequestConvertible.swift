import Foundation
import RxSwift

protocol CoreRequestConvertible {
    associatedtype Output: Codable
    associatedtype Request: CoreRequestConvertible where Request.Output == Output
    
    var base: Request { get }
    func toCoreRequest(_ core: DCore.Sdk) -> Single<Output>
}

extension CoreRequestConvertible where Request: BaseRequest<Output> {
    func toCoreRequest(_ core: DCore.Sdk) -> Single<Output> {
        return core.make(request: self.base)
    }
}


