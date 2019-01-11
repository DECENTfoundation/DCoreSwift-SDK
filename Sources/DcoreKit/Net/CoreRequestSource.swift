import Foundation
import RxSwift

protocol CoreRequestSource {
    func request<Output>(using req: BaseRequest<Output>) -> Single<Output> where Output: Codable
    func request<Output>(usingStream req: BaseRequest<Output>) -> Observable<Output> where Output: Codable
}

extension CoreRequestSource {
    func request<Output>(using req: BaseRequest<Output>) -> Single<Output> where Output: Codable {
        return Single.error(ChainException.unexpected("Api calls not implemented"))
    }
    
    func request<Output>(usingStream req: BaseRequest<Output>) -> Observable<Output> where Output: Codable {
        return Observable.error(ChainException.unexpected("Api steam calls not implemented"))
    }
}
