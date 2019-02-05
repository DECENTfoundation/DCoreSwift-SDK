import Foundation

public struct ApiProvider {
    
    public let api: DCore.Api
    
    public init(using api: DCore.Api) {
        self.api = api
    }
}
