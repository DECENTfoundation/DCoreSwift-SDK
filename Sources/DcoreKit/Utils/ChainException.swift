import Foundation
import SwiftyJSON

public enum ChainException: Error {

    public enum Network: Error, Equatable {
        case
        notFound,
        closed,
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
        failDecode(String),
        notEnoughSpace
    }
    
    init(from error: Error) {
        switch true {
        case error is ChainException:
            self = error as! ChainException
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
        case .failDecode(let message): return message
        case .notEnoughSpace: return "Not enough space"
        }
    }
}

extension ChainException: Equatable {
    public static func == (lhs: ChainException, rhs: ChainException) -> Bool {
        switch (lhs, rhs) {
        case (.chain(let a), .chain(let b)): return a == b
        case (.network(let a), .network(let b)): return a == b
        case (.crypto(let a), .crypto(let b)): return a == b
        case (.unexpected(let a), .unexpected(let b)): return a == b
            
        default:
            return false
        }
    }
}
