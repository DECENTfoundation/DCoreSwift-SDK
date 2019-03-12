import Foundation
import RxSwift
import Alamofire

extension Reactive where Base: URLSession {
    func asData(request: URLRequest, queue: DispatchQueue) -> Single<Data> {
        return Single.create { event in
            var task: URLSessionDataTask?
            queue.async {
                task = self.base.dataTask(with: request) { data, response, error in
                    if let response = response as? HTTPURLResponse, let data = data, 200 ..< 300 ~= response.statusCode {
                        event(.success(data))
                    } else if let error = error {
                        event(.error(error.asDCoreException()))
                    } else {
                        event(.error(DCoreException.unexpected("Rest service has invalid response")))
                    }
                }
                task?.resume()
            }
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}
