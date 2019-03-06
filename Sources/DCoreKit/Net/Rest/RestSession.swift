import Foundation

final class RestSession: NSObject, URLSessionDelegate {
    
    let session: URLSession
    
    init(_ session: URLSession) {
        self.session = session
    }
}
