import Foundation
import RxSwift
import RxCocoa

final class RestService: CoreRequestConvertible {

    private let url: URL
    private let session: URLSession
    private let scheduler = SerialDispatchQueueScheduler(qos: .default)
    
    init(_ url: URL, session: URLSession? = nil) {
        self.url = url
        self.session = session ?? URLSession(configuration: .default)
    }
    
    func request<Output>(using req: BaseRequest<Output>) -> Single<Output> where Output: Codable {
        return session.rx.data(request: req.asRest(url))
            .observeOn(scheduler)
            .delay(0.1, scheduler: scheduler) // Added delay for some weird bug with url session sequenced calls 
            .map { res in
                do { return try res.parse(response: req) } catch let error {
                    throw error.asChainException()
                }
            }.asSingle()
    }
}
