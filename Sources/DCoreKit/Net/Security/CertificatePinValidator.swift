import Foundation

struct CertificatePinValidator: ServerTrustValidation {
    private let pins: [Pair<String, String>]
    
    public init(pin: Pair<String, String>) {
        self.init(pins: [pin])
    }
    
    public init(pins: [Pair<String, String>]) {
        precondition(!pins.isEmpty, "Certifcate pin validator does not contain pins")
        self.pins = pins
    }
    
    public func custom(trust: SecTrust, for host: String) throws {
        let localPins = pins.filter { $0.first == host || $0.first.contains(host) || host.contains($0.first) }
        guard !Set(localPins.map { $0.second }).isDisjoint(with: trust.certificatePins) else {
            throw DCoreException.network(.security("Certificate pin does not match"))
        }
    }
}
