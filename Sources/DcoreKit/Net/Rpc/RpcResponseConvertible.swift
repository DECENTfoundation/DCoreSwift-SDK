import Foundation

protocol RpcResponseConvertible: Decodable {
    associatedtype Output: Codable
    
    var result: AnyValue? { get set }
    var error: AnyValue? { get set }
    
    func create(responseFor request: BaseRequest<Output>, data: Data, path: String) throws -> RpcResponse<Output>
}

extension RpcResponseConvertible where Output: Codable {
    
    func create(responseFor request: BaseRequest<Output>, data: Data, path: String) throws -> RpcResponse<Output> {
        /*
        if let error = error { throw CoreError.network(.response(error)) }
        
        if let _ = result, request.returnClass == UnitValue.self {
            return .result(UnitValue.Void as! Output) // force cast
        }
        
        guard let result = result, case .array(let value) = result, !value.isEmpty else { throw CoreError.network(.notFound) }
        
        let value = try data.fromJson(type: request.returnClass, at: path)
        return .result(value)
         */
        
        fatalError()
    }
}
