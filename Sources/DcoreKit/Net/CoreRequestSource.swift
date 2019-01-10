import Foundation
import RxSwift

protocol CoreRequestSource {
    func request<Output>(using req: BaseRequest<Output>) -> Single<Output> where Output: Codable
}

extension CoreRequestSource {
    func request<Output>(using req: BaseRequest<Output>) -> Single<Output> where Output: Codable {
        return Single.error(ChainException.unexpected("Api call not implemented"))
    }
}
