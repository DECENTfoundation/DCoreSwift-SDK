import Foundation

private extension SecTrust {
    func validate(policy: SecPolicy) throws {
        try set(policy: policy).perform()
    }
    
    private func set(policy: SecPolicy) throws -> SecTrust {
        let result = SecTrustSetPolicies(self, policy)
        guard result == errSecSuccess else {
            throw DCoreException.network(.security("Server trust verification could not be performed"))
        }
        return self
    }
    
    private func perform() throws {
        var result = SecTrustResultType.invalid
        let status = SecTrustEvaluate(self, &result)
        
        guard status == errSecSuccess && (result == .unspecified || result == .proceed) else {
            throw DCoreException.network(.security("Server trust validation failed"))
        }
    }
}

private extension SecPolicy {
    static let standard = SecPolicyCreateSSL(true, nil)
    
    static func host(name: String) -> SecPolicy {
        return SecPolicyCreateSSL(true, name as CFString)
    }
}

public protocol ServerTrustValidation {
    func validate(trust: SecTrust, for host: String) throws
    func custom(trust: SecTrust, for host: String) throws
}

public extension ServerTrustValidation {
    public func validate(trust: SecTrust, for host: String) throws {
        try trust.validate(policy: .host(name: host))
        try trust.validate(policy: .standard)
        try custom(trust: trust, for: host)
    }
}
