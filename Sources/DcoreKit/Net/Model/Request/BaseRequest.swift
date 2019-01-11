import Foundation
import RxSwift

struct BaseRequest<Output: Codable>: Encodable, CoreResponseConvertible, RestConvertible, WssConvertible {
    
    typealias Request = BaseRequest
    var base: BaseRequest<Output> { return self }
    
    private let method: ApiMethod = .call
    private let jsonrpc: Rpc = .version
    private let group: ApiGroup
    private let api: String
    private let params: [AnyEncodable]

    let returnClass: Output.Type
    let returnKeypath: String = "result"
    let callback: Bool
    
    var callId: UInt64 = 1
    var callbackId: UInt64? = nil
   
    init(_ group: ApiGroup, api: String, returnClass: Output.Type, params: [Encodable] = [], callback: Bool = false) {
        self.group = group
        self.api = api
        self.returnClass = returnClass
        self.params = params.map({ AnyEncodable($0) })
        self.callback = callback
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
    
    func with(id: UInt64) -> BaseRequest<Output> {
        var request = self
        
        if callback { request.callbackId = id }
        request.callId = id
        
        return request
    }
}

extension BaseRequest: CustomStringConvertible {
    var description: String {
        guard let json = try? asJson() else { fatalError("Base request description not supported") }
        return json
    }
}
