import Foundation

public struct PublicKeysValidator: ServerTrustValidation {
    private let keys: [Pair<String, SecKey>]

    public init(key: Pair<String, SecKey>) {
        self.init(keys: [key])
    }
    
    public init(keys: [Pair<String, SecKey>]) {
        precondition(!keys.isEmpty, "Public keys validator does not contain keys")
        self.keys = keys
    }
    
    public func custom(trust: SecTrust, for host: String) throws {
        let result = keys.filter { $0.first == host || $0.first.contains(host) || host.contains($0.first) }
        guard !Set(result.map { $0.second }).isDisjoint(with: trust.publicKeys) else {
            throw DCoreException.network(.security("Public key does not match"))
        }
    }
}
