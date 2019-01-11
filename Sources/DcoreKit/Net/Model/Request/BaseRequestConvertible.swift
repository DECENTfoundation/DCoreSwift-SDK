import Foundation

protocol BaseRequestConvertible {
    associatedtype Output
    
    var request: AnyRequest<Output> { get set }
    static func to(_ group: ApiGroup, api: String, returnClass: Output.Type, params: [Encodable]) -> AnyRequest<Output>
}

extension BaseRequestConvertible {
    static func to(_ group: ApiGroup, api: String, returnClass: Output.Type, params: [Encodable]) -> AnyRequest<Output> {
        return AnyRequest(group, api: api, returnClass: returnClass, params: params)
    }
}

struct AnyRequest<Output> {
    
    init(_ group: ApiGroup, api: String, returnClass: Output.Type, params: [Encodable]) {
    }
}


struct BroadcastTransaction2: BaseRequestConvertible {
    typealias Output = UnitValue
    var request: AnyRequest<UnitValue>
    
    init(using trx: Transaction) {
        precondition(!trx.signatures!.isEmpty, "Transaction not signed, forgot to call .withSignature(key) ?")
        self.request = BroadcastTransaction2.to(.broadcast, api: "broadcast_transaction", returnClass: UnitValue.self, params: [trx])
    }
}
