import Foundation
import RxSwift

protocol CoreRequestConvertible {
    func request<Output>(using req: BaseRequest<Output>) -> Single<Output> where Output: Codable
    func request<Output>(usingStream req: BaseRequest<Output>) -> Observable<Output> where Output: Codable
}

extension CoreRequestConvertible {
    func request<Output>(using req: BaseRequest<Output>) -> Single<Output> where Output: Codable {
        return Single.error(DCoreException.unexpected("Api calls not implemented"))
    }
    
    func request<Output>(usingStream req: BaseRequest<Output>) -> Observable<Output> where Output: Codable {
        return Observable.error(DCoreException.unexpected("Api steam calls not implemented"))
    }
}
