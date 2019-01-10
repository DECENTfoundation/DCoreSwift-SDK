import Foundation

enum RestResultValidator: CoreResultConvertible {
    
    case unknown
    case success(AnyValue)
    case failure(AnyValue)
    
    @discardableResult
    init(_ data: Data) throws {
        self = try data.asJsonDecoded(to: RestResultValidator.self)
        switch self {
        case .failure(let value):
            throw ChainException.network(.failAny(value))
        case .success(let value):
            
            switch value {
            case .array(let elements) where elements.isEmpty: fallthrough
            case .null:
                throw ChainException.network(.notFound)
            default:
                return
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
