import Foundation

extension DCore {
    
    public class Sdk {
        
        private let client: Any
        private let socketUrl: String?
        private let httpUrl: String?
        
        init(client: Any, socketUrl: String? = nil, httpUrl: String? = nil) {
            self.client = client
            self.socketUrl = socketUrl
            self.httpUrl = httpUrl
        }
        
        public static func create(forHttp client: Any, url: String) -> Api {
            return Api(core: Sdk(client: client, httpUrl: url))
        }
        
        public static func create(forWebSocket client: Any, url: String) -> Api {
            return Api(core: Sdk(client: client, socketUrl: url))
        }
        
        public static func create(for client: Any, socketUrl: String, httpUrl: String) -> Api {
            return Api(core: Sdk(client: client, socketUrl: socketUrl, httpUrl: httpUrl))
        }
    }
}
