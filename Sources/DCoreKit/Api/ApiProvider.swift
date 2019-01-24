import Foundation

struct ApiProvider {
    
    let api: DCore.Api
    
    init(using api: DCore.Api) {
        self.api = api
    }
}
