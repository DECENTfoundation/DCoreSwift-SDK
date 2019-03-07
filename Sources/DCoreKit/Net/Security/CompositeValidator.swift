import Foundation

public struct CompositeValidator: ServerTrustValidation {
    private let validators: [ServerTrustValidation]
    
    public init(_ validators: [ServerTrustValidation]) {
        self.validators = validators
    }
    
    public func custom(trust: SecTrust, for host: String) throws {
        try validators.forEach { try $0.custom(trust: trust, for: host) }
    }
}
