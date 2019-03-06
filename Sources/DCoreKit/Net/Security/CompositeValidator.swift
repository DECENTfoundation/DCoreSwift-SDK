import Foundation

public struct CompositeValidator: ServerTrustValidation {
    private let validators: [ServerTrustValidation]
    
    public init(_ validators: [ServerTrustValidation]) {
        self.validators = validators
    }
    
    public func configured(trust: SecTrust, for host: String) throws {
        try validators.forEach { try $0.configured(trust: trust, for: host) }
    }
}
