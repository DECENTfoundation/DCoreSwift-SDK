import Foundation
import RxSwift

protocol CoreResponseConvertible {
    associatedtype Output: Codable
    associatedtype Request: CoreResponseConvertible where Request.Output == Output

    var base: Request { get }
    
    func isResponseVoid() -> Bool
    func toResponse(_ core: DCore.Sdk) -> Single<Output>
    func toStreamResponse(_ core: DCore.Sdk) -> Observable<Output>
    
}

extension CoreResponseConvertible where Request == BaseRequest<Output> {
    
    func isResponseVoid() -> Bool { return false }
    
    func toResponse(_ core: DCore.Sdk) -> Single<Output> {
        return core.make(request: self.base)
    }
    
    func toStreamResponse(_ core: DCore.Sdk) -> Observable<Output> {
        return core.make(streamRequest: self.base)
    }
}

extension CoreResponseConvertible where Request == BaseRequest<Output>, Request.Output == UnitValue {
    
    func isResponseVoid() -> Bool { return true }
}
