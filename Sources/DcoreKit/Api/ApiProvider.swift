import Foundation

public protocol BaseApi {
    var api: DCore.Api { get }
}

struct ApiProvider {
    
    let api: DCore.Api
    
    init(using api: DCore.Api) {
        self.api = api
    }
}
