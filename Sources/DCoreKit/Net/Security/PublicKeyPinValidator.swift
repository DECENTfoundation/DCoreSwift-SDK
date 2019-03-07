import Foundation

struct PublicKeyPinValidator: ServerTrustValidation {
    
    private let pins: [Pair<String, String>]
    
    public init(pin: Pair<String, String>) {
        self.init(pins: [pin])
    }
    
    public init(pins: [Pair<String, String>]) {
        precondition(!pins.isEmpty, "Public key pin validator does not contain pins")
        self.pins = pins
    }
    
    public func custom(trust: SecTrust, for host: String) throws {
        let localPins = pins.filter { $0.first == host || $0.first.contains(host) || host.contains($0.first) }
        guard !Set(localPins.map { $0.second }).isDisjoint(with: trust.publicKeyPins) else {
            throw DCoreException.network(.security("Public key pin doest not match"))
        }
    }
}
