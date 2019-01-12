import Foundation
import RxSwift
import RxCocoa

final class RestService: CoreRequestConvertible {

    private let url: URL
    private let session: URLSession
    
    init(_ url: URL, session: URLSession? = nil) {
        self.url = url
        self.session = session ?? URLSession(configuration: .default)
    }
    
    func request<Output>(using req: BaseRequest<Output>) -> Single<Output> where Output: Codable {
        return session.rx.data(request: req.asRest(url))
            .map { res in
                do { return try res.parse(response: req) } catch let error {
                    throw error.asChainException()
                }
            }.asSingle()
    }
}
