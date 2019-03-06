import Foundation

struct CompositeValidator: ServerTrustValidation {
    
    private let validators: [ServerTrustValidation]
    
    init(_ validators: [ServerTrustValidation]) {
        self.validators = validators
    }
    
    func configured(trust: SecTrust, for host: String) throws {
        try validators.forEach { try $0.configured(trust: trust, for: host) }
    }
}
