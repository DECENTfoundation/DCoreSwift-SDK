import Foundation

enum RestResultValidator: ChainResultConvertible {
    
    var result: Data {
        guard case .result(let value) = self else { fatalError("Unexpected result of rest validator") }
        return value
    }
    
    case unknown
    case success(AnyValue)
    case failure(AnyValue)
    case result(Data)
    
    @discardableResult
    init(_ data: Data) throws {
        let sample = try data.asJsonDecoded(to: RestResultValidator.self)
        switch sample {
        case .failure(let value):
            throw ChainException.network(.failAny(value))
        case .success(let value):
            
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
        
        if let value = try? container.decode(AnyValue.self, forKey: .error) {
            self = .failure(value)
        } else if let value = try? container.decode(AnyValue.self, forKey: .result) {
            self = .success(value)
        } else {
            self = .unknown
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case
        result,
        error
    }
    
}
