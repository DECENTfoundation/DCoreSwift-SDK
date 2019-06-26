import Foundation
import RxSwift

struct BaseRequest<Output: Codable>: CoreResponseConvertible, RestConvertible, WssConvertible {
    
    typealias Request = BaseRequest
    var base: BaseRequest<Output> { return self }
    
    private let method: ApiMethod = .call
    private let jsonrpc: Rpc = .version
    private let group: ApiGroup
    private let api: String
    private let params: [AnyEncodable]

    let returnType: Output.Type
    let callback: Bool
    
    var callId: UInt64 = 1
    var callbackId: UInt64?
   
    init(_ group: ApiGroup, api: String, returnType: Output.Type, params: [Encodable] = [], callback: Bool = false) {
        self.group = group
        self.api = api
        self.returnType = returnType
        self.params = params.map({ AnyEncodable($0) })
        self.callback = callback
    }
    
    func apply(id: UInt64) -> BaseRequest<Output> {
        
        var req = self
        if callback { req.callbackId = id }
        req.callId = id
        
        return req
    }
}

extension BaseRequest: Encodable {
    
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
        
        try unkeyed.encode(group.name)
        try unkeyed.encode(api)
        
        // json rpc params
        var nestedUnkeyed = unkeyed.nestedUnkeyedContainer()
        if let callbackId = callbackId {
            try nestedUnkeyed.encode(callbackId)
        }
        
        try nestedUnkeyed.encode(contentsOf: params)
    }
}

extension BaseRequest: CustomStringConvertible {
    var description: String {
        return asJson().or("")
    }
}
