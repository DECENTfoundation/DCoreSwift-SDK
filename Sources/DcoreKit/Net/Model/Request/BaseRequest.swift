import Foundation
import RxSwift

class BaseRequest<Output: Codable>: Encodable, CoreRequestConvertible, RestConvertible, WssConvertible {
    typealias Request = BaseRequest

    private let group: ApiGroup
    private let api: String
    
    let params: [AnyEncodable]
    let returnClass: Output.Type
    let returnKeypath: String = "result"
    
    var base: BaseRequest<Output> { return self }
    var method: String = DCore.Constant.Api.method
    var jsonrpc: String = DCore.Constant.Api.jsonrpc
    
    var callId: UInt64 = 1
    var callbackId: UInt64?
    
    init(_ group: ApiGroup, api: String, returnClass: Output.Type, params: [Encodable] = []) {
        self.group = group
        self.api = api
        self.returnClass = returnClass
        self.params = params.map({ AnyEncodable($0) })
    }
    
    private enum CodingKeys: String, CodingKey {
        case
        jsonrpc,
        method,
        params,
        id
    }
    
    func encode(to encoder: Encoder) throws {
        
        // json rpc root
        var keyed = encoder.container(keyedBy: CodingKeys.self)
        try keyed.encode(jsonrpc, forKey: .jsonrpc)
        try keyed.encode(method, forKey: .method)
        try keyed.encode(callId, forKey: .id)
        
        // json rpc group and api
        var unkeyed = keyed.nestedUnkeyedContainer(forKey: .params)
        
        try unkeyed.encode(group.id)
        try unkeyed.encode(api)
        
        // json rpc params
        var nestedUnkeyed = unkeyed.nestedUnkeyedContainer()
        if let callbackId = callbackId {
            try nestedUnkeyed.encode(callbackId)
        }
        
        try nestedUnkeyed.encode(contentsOf: params)
    }
    
    func with(callback id: UInt64) -> Self {
        self.callId = id
        self.callbackId = id
        
        return self
    }
}

extension BaseRequest: CustomStringConvertible {
    var description: String {
        return "\(group.description):\(api)"
    }
}
