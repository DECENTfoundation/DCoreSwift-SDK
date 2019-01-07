import Foundation
import RxSwift
import RxCocoa

class RpcService {

    private let url: URL
    private let session: URLSession
    
    init(_ url: URL, session: URLSession? = nil) {
        self.url = url
        self.session = session ?? URLSession(configuration: URLSessionConfiguration.default)
    }
    
    func request<Output: Codable>(using request: BaseRequest<Output>) -> Single<Output> {
        return session.rx.data(request: request.toPostJson(url))
            .asSingle()
            .flatMap({ data in
                do {
                    switch try RpcResponse(request, data: data) {
                    case .result(let value): return Single.just(value)
                    }
                } catch let underlying {
                    return Single.error(CoreError(from: underlying))
                }
            })
    }
}
