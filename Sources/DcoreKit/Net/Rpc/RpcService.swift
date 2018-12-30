import Foundation
import RxSwift
import RxCocoa

class RpcService {

    private let url: URL
    private let client: URLSession
    
    init(_ url: URL, client: URLSession? = nil) {
        self.url = url
        self.client = client ?? URLSession(configuration: URLSessionConfiguration.default)
    }
    
    func request<T: Codable>(using request: BaseRequest<T>) -> Single<T> {
        return client.rx.data(request: request.postJson(url, timeout: 0)).asSingle().flatMap({ data in
            do {
                switch try RpcResponse(request, data: data) {
                case .result(let value): return Single.just(value)
                case .failure(let error): return Single.error(error)
                }
            } catch let error {
                return Single.error(DCoreError.underlying(error))
            }
        })
    }
}
