import Foundation
import RxSwift

protocol CoreResponseConvertible {
    associatedtype Output: Codable
    associatedtype Request: CoreResponseConvertible where Request.Output == Output
    
    var base: Request { get }
    
    func isResponseVoid() -> Bool
    func toResponse(_ core: DCore.Sdk) -> Single<Output>
}

extension CoreResponseConvertible where Request == BaseRequest<Output> {
    
    func isResponseVoid() -> Bool { return false }
    
    func toResponse(_ core: DCore.Sdk) -> Single<Output> {
        guard self.base.callback else { return core.make(request: self.base) }
        return core.make(streamRequest: self.base).asSingle()
    }
}

extension CoreResponseConvertible where Request == BaseRequest<Output>, Request.Output == UnitValue {
    
    func isResponseVoid() -> Bool { return true }
}
