import Foundation
import SwiftyJSON

public enum ChainException: Error {
    
    public enum Network: Error, Equatable {
        case
        notFound,
        closed,
        stack(Int, String, String),
        fail(JSON),
        failDecode(String),
        failEncode(String)
    }
    
    public enum Chain: Error, Equatable {
        case
        failConvert(String)
    }
    
    public enum Crypto: Error, Equatable {
        case
        failSigning,
        failMultiply,
        failDecode(String),
        failDecrypt(String),
        failEncrypt(String),
        notEnoughSpace
    }
    
    public var isStack: Bool {
        guard case .network(let value) = self, case .stack(_, _, _) = value else { return false }
        return true
    }
    
    init(from error: Error) {
        switch true {
        case error is ChainException:
            self = error as! ChainException // swiftlint:disable:this force_cast
        default:
            self = .underlying(error)
        }
    }
    
    case
    network(Network),
    chain(Chain),
    crypto(Crypto),
    unexpected(String),
    underlying(Error)
}

extension ChainException: CustomStringConvertible {
    public var description: String {
        switch self {
        case .network(let network): return network.description
        case .chain(let chain): return chain.description
        case .crypto(let crypto): return crypto.description
        case .unexpected(let message): return message
        case .underlying(let error): return "Underlying exception \(error)"
        }
    }
}

extension ChainException.Network: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notFound: return "Result not found"
        case .closed: return "Network was closed"
        case .stack(let code, let name, let message): return "\(name) (\(code)): \(message)"
        case .fail(let value): return value.description
        case .failDecode(let message): return message
        case .failEncode(let message): return message
        }
    }
}

extension ChainException.Chain: CustomStringConvertible {
    public var description: String {
        switch self {
        case .failConvert(let message): return message
        }
    }
}

extension ChainException.Crypto: CustomStringConvertible {
    public var description: String {
        switch self {
        case .failSigning: return "Singing failed"
        case .failMultiply: return "Multiplication failed"
        case .failDecode(let message): return message
        case .failDecrypt(let message): return message
        case .failEncrypt(let message): return message
        case .notEnoughSpace: return "Not enough space"
        }
    }
}

extension ChainException.Network: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case
        name,
        code,
        message
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let code = try container.decode(Int.self, forKey: .code)
        let name = try container.decode(String.self, forKey: .name)
        let message = try container.decode(String.self, forKey: .message)
        
        self = .stack(code, name, message)
    }
}

extension ChainException: Equatable {
    public static func == (lhs: ChainException, rhs: ChainException) -> Bool {
        switch (lhs, rhs) {
        case (.chain(let left), .chain(let right)): return left == right
        case (.network(let left), .network(let right)): return left == right
        case (.crypto(let left), .crypto(let right)): return left == right
        case (.unexpected(let left), .unexpected(let right)): return left == right
            
        default:
            return false
        }
    }
}
