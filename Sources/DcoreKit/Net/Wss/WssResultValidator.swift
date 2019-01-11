import Foundation

enum WssResultValidator<Output>: CoreResultConvertible where Output: Codable {
    
    var result: Data {
        guard case .result(let value) = self else { fatalError("Unexpected result of wss validator") }
        return value
    }
    
    case unknown
    case success(AnyValue, UInt64, UInt64)
    case failure(AnyValue, UInt64)
    case result(Data)
    
    @discardableResult
    init(_ req: BaseRequest<Output>, data: Data) throws {
        let sample = try data.asJsonDecoded(to: WssResultValidator.self)
        switch sample {
        case .failure(let value, let callId):
            if callId == req.callId {
                throw ChainException.network(.failAny(value))
            } else {
                self = sample
            }
            
        case .success(let value, let callId, let callback):
            
            switch value {
            case .array(let elements) where elements.isEmpty: fallthrough
            case .null:
                throw ChainException.network(.notFound)
            default:
                self = .result(data)
            }
        default:
            throw ChainException.unexpected("Invalid rest api response result")
        }
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(UInt64.self, forKey: .id)
        if let value = try? container.decode(AnyValue.self, forKey: .error) {
            self = .failure(value, id)
        } else if let value = try? container.decode(AnyValue.self, forKey: .result) {
            self = .success(value, id, 0)
        } else {
            self = .unknown
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case
        result,
        id,
        error
    }
}


/*
 if (it.has("method") && it.get("method").asString == "notice") {
 it.get("params").asJsonArray.let {
 val id = it[0].asLong
 val result = it[1].asJsonArray[0]
 id to JsonObject().apply { add("result", result) }
 }
 } else {
 it.get("id").asLong to it
 }
 */
