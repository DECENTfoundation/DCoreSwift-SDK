import Foundation

open class ServerTrustDelegate: NSObject, URLSessionDelegate {
    public internal(set) weak var provider: SecurityProvider?
}

extension ServerTrustDelegate {
    public func urlSession(_ session: URLSession,
                           didReceive challenge: URLAuthenticationChallenge,
                           completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        switch challenge.protectionSpace.authenticationMethod {
        case NSURLAuthenticationMethodServerTrust:
            let host = challenge.protectionSpace.host
            let trust = challenge.protectionSpace.serverTrust
            if let trust = trust, let validator = provider?.validator {
                do {
                    try validator.validate(trust: trust, for: host)
                    completionHandler(.useCredential, URLCredential(trust: trust))
                } catch let error {
                    DCore.Logger.error(network: "Server trust for rest failed with error %{public}s", args: {
                        error.asDCoreException().description
                    })
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
