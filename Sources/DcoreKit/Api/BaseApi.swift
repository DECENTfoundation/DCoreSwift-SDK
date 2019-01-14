import Foundation

public class BaseApi {
    
    let api: DCore.Api
    
    required init(using api: DCore.Api) {
        self.api = api
    }
}
