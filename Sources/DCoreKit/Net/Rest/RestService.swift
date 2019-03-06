import Foundation
import RxSwift
import RxCocoa

final class RestService: CoreRequestConvertible {

    private let url: URL
    private let session: URLSession
    
    init(_ url: URL, session: URLSession? = nil) {
        self.url = url
        self.session = session.or(URLSession(configuration: .default))
    }
    
    func request<Output>(using req: BaseRequest<Output>) -> Single<Output> where Output: Codable {
        return Observable.deferred { [unowned self] in
            // TODO: DWI-81 URL session from member property should be used
            return URLSession(configuration: .default).rx.data(request: req.asRest(self.url))
                .map { res in
                    
                    do { return try res.parse(response: req) } catch let error {
                        throw error.asDCoreException()
                    }
                }
        }.asSingle()
    }
}
