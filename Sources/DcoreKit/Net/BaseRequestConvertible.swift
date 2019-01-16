import Foundation

protocol BaseRequestConvertible {
    associatedtype Output: Codable
    
    var base: BaseRequest<Output> { get }
    static func toBase(_ group: ApiGroup,
                       api: String,
                       returnType: Output.Type,
                       params: [Encodable]) -> BaseRequest<Output>
    
    static func toBaseCallback(_ group: ApiGroup,
                               api: String,
                               returnType: Output.Type,
                               params: [Encodable]) -> BaseRequest<Output>
}

extension BaseRequestConvertible {
    static func toBase(_ group: ApiGroup,
                       api: String,
                       returnType: Output.Type,
                       params: [Encodable] = []) -> BaseRequest<Output> {
        return BaseRequest(group, api: api, returnType: returnType, params: params)
    }
    static func toBaseCallback(_ group: ApiGroup,
                               api: String,
                               returnType: Output.Type,
                               params: [Encodable] = []) -> BaseRequest<Output> {
        return BaseRequest(group, api: api, returnType: returnType, params: params, callback: true)
    }
}
