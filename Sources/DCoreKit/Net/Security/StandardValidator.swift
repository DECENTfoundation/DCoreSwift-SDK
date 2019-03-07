import Foundation

public struct StandardValidator: ServerTrustValidation {
    public func custom(trust: SecTrust, for host: String) throws {}
}
