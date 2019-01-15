import Foundation

public class DeprecatedService: BaseApi {
    
    public let api: DCore.Api
    
    required init(using api: DCore.Api) {
        self.api = api
    }
}
