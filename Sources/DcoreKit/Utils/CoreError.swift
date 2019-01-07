import Foundation

public enum CoreError: Error {

    public enum Network: Error {
        case
        notFound,
        failResult(AnyValue),
        failDecode(String),
        failEncode(String)
    }
    
    public enum Chain: Error {
        case
        failConversion(String)
    }
    
    public enum Crypto: Error {
        case
        failSigning,
        failDecode(String),
        notEnoughSpace
    }
    
    init(from underlying: Error) {
        switch true {
        case underlying is Network:
            self = .network(underlying as! Network)
        case underlying is Chain:
            self = .chain(underlying as! Chain)
        case underlying is Crypto:
            self = .crypto(underlying as! Crypto)
        default:
            self = .underlying(underlying)
        }
    }
    
    case
    network(Network),
    chain(Chain),
    crypto(Crypto),
    
    unexpected(String),
    underlying(Error)
}

extension CoreError: CustomStringConvertible {
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

extension CoreError.Network: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notFound: return "Result not found"
        case .failResult(let value): return value.description
        case .failDecode(let message): return message
        case .failEncode(let message): return message
        }
    }
}

extension CoreError.Chain: CustomStringConvertible {
    public var description: String {
        switch self {
        case .failConversion(let message): return message
        }
    }
}

extension CoreError.Crypto: CustomStringConvertible {
    public var description: String {
        switch self {
        case .failSigning: return "Singing failed"
        case .failDecode(let message): return message
        case .notEnoughSpace: return "Not enough space"
        }
    }
}
