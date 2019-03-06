import Foundation

final class RestSecurityDelegate: NSObject {
    weak var provider: SecurityProvider?
}

extension RestSecurityDelegate: URLSessionDelegate {
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        switch challenge.protectionSpace.authenticationMethod {
        case NSURLAuthenticationMethodServerTrust:
            let host = challenge.protectionSpace.host
            let trust = challenge.protectionSpace.serverTrust
            if let trust = trust {
                do {
                    try provider?.validator?.validate(trust: trust, for: host)
                    completionHandler(.useCredential, URLCredential(trust: trust))
                } catch {
                    completionHandler(.cancelAuthenticationChallenge, nil)
                }
            } else {
                fallthrough
            }
        default:
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
