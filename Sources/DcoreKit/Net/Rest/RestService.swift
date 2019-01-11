import Foundation
import RxSwift
import RxCocoa

final class RestService: CoreRequestSource {

    private let url: URL
    private let session: URLSession
    
    init(_ url: URL, session: URLSession? = nil) {
        self.url = url
        self.session = session ?? URLSession(configuration: .default)
    }
    
    func request<Output>(using req: BaseRequest<Output>) -> Single<Output> where Output: Codable {
        return session.rx.data(request: req.asRest(url))
            .map { data in
                do {
                    return try data.asJsonDecoded(to: req) { try RestResultValidator($0) }
                } catch let error {
                    throw error.asChainException()
                }
            }.asSingle()
    }
}
