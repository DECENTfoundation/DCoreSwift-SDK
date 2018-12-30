import Foundation
import RxSwift

protocol CoreRequestSource {
    associatedtype Response: Codable
    associatedtype ResponseRelay: ObservableType where ResponseRelay.E == Response
    
    func request<Response>(using req: BaseRequest<Response>) -> ResponseRelay
}
