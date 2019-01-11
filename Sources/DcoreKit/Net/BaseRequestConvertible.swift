import Foundation

protocol BaseRequestConvertible {
    associatedtype Output: Codable
    
    var base: BaseRequest<Output> { get }
    static func toBase(_ group: ApiGroup, api: String, returnClass: Output.Type, params: [Encodable]) -> BaseRequest<Output>
    static func toBaseCallback(_ group: ApiGroup, api: String, returnClass: Output.Type, params: [Encodable]) -> BaseRequest<Output>
}

extension BaseRequestConvertible {
    static func toBase(_ group: ApiGroup, api: String, returnClass: Output.Type, params: [Encodable] = []) -> BaseRequest<Output> {
        return BaseRequest(group, api: api, returnClass: returnClass, params: params)
    }
    
    static func toBaseCallback(_ group: ApiGroup, api: String, returnClass: Output.Type, params: [Encodable] = []) -> BaseRequest<Output> {
        return BaseRequest(group, api: api, returnClass: returnClass, params: params, callback: true)
    }
}
