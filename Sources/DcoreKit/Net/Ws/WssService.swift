import Foundation
import RxSwift

class WssService {
    
    private let url: URL
    
    init(_ url: URL) {
        self.url = url
    }
    
    func request<T: Codable>(using req: BaseRequest<T>) -> Single<T> {
        fatalError("Not implemented")
    }
}
