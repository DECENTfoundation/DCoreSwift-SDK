import Foundation
import RxSwift

class BaseRequest<T> {
    
    let apiGroup: ApiGroup
    let method: String
    let returnClass: T.Type
    let params: [Any]
    
    var jsonrpc: String = "2.0"
    var id: Int = 1
    
    init(api group: ApiGroup, method: String, returnClass: T.Type, params: [Any] = []) {
        self.apiGroup = group
        self.method = method
        self.returnClass = returnClass
        self.params = params
    }
}

extension BaseRequest: Encodable {
    
    private enum CodingKeys: String, CodingKey {
        case
        method,
        jsonrpc,
        params,
        id
    }
    
    public func encode(to encoder: Encoder) throws {
        var keyed = encoder.container(keyedBy: CodingKeys.self)
        try keyed.encode(self.method, forKey: .method)
        try keyed.encode(self.id, forKey: .id)
        
    }
}

extension BaseRequest: CustomStringConvertible {
    var description: String {
        return "\(self.method)"
    }
}

extension BaseRequest {
    func toRequest(core: DCore.Sdk) -> Single<T> {
        return core.make(request: self)
    }
}

enum Params: Encodable {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    case array([Params])
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        switch self {
        case .string(let value):    try container.encode(value)
        case .int(let value):       try container.encode(value)
        case .double(let value):    try container.encode(value)
        case .bool(let value):      try container.encode(value)
        case .array(let value):     try container.encode(contentsOf: value)
        }
    }
}

