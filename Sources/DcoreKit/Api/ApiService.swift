import Foundation

public protocol BaseApi {
    var api: DCore.Api { get }
}

public struct ApiProvider {
    
    public let api: DCore.Api
    
    init(using api: DCore.Api) {
        self.api = api
    }
}
