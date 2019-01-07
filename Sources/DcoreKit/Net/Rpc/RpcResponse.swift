import Foundation

enum RpcResponse<T: Codable> {
    
    case
    result(T)
    
    init(_ request: BaseRequest<T>, data: Data) throws {
        
        fatalError("Not")
        // let factory = try data.fromJson(type: RpcResult.self)
        // self = try factory.create(responseFor: request, data: data, path: RpcResult.CodingKeys.result.rawValue)
    }
    
    
}
/*
fileprivate struct RpcResult: RpcResponseConvertible {
    
    let result: AnyValue?
    let error: AnyValue?
    
    fileprivate enum CodingKeys: String, CodingKey {
        case
        result,
        error
    }
}*/
