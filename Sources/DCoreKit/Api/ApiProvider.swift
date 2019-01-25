import Foundation

public struct ApiProvider {
    
    public let api: DCore.Api
    
    init(using api: DCore.Api) {
        self.api = api
    }
}
