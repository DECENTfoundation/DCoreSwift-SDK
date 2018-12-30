import Foundation

protocol RpcResponseConvertible: Decodable {
    associatedtype T: Codable
    
    var result: AnyValue? { get set }
    var error: AnyValue? { get set }
    
    func create(responseFor request: BaseRequest<T>, data: Data, path: String) throws -> RpcResponse<T>
}

extension RpcResponseConvertible where T: Codable {
    
    func create(responseFor request: BaseRequest<T>, data: Data, path: String) throws -> RpcResponse<T> {
        if let error = error {
            return .failure(DCoreError.failure(error))
        }
        
        if let _ = result, request.returnClass == UnitValue.self {
            return .result(UnitValue.Void as! T) // force cast
        }
        
        if let result = result, case .array(let value) = result, value.isEmpty {
            return .failure(DCoreError.notFound(request.description))
        }
        
        let value = try data.fromJson(type: request.returnClass, at: path)
        return .result(value)
    }
}
