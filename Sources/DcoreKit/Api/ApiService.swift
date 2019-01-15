import Foundation

public protocol BaseApi {
    var api: DCore.Api { get }
}

public struct ApiService {
    
    public let api: DCore.Api
    
    init(using api: DCore.Api) {
        self.api = api
    }
}

public class DeprecatedService: BaseApi {
    
    public let api: DCore.Api
    
    required init(using api: DCore.Api) {
        self.api = api
    }
}
