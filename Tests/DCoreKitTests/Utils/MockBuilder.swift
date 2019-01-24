import Foundation
import Hippolyte

@testable import DCoreKit

enum Mock {
    static func build(using url: URLConvertible, data: Data, status: Int = 200) -> StubRequest {
        let response = StubResponse.Builder().stubResponse(withStatusCode: status).addBody(data).build()
        return StubRequest.Builder()
            .stubRequest(withMethod: .POST, url: url.asURL()!)
            .addHeader(withKey: "Content-Type", value: Http.Header.ContentType.applicationJson.rawValue)
            .addResponse(response)
            .build()
    }
}
