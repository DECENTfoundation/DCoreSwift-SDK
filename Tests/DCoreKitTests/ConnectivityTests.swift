import XCTest
import RxSwift
import RxBlocking

@testable import DCoreKit

class ConnectivityTests: XCTestCase {
    
    private let wss = DCore.Sdk.create(forWss: "wss://api.decent.ch")
    
    func testWebSocketReconnection() {
        let id = "1.2.11368".dcore.chainObject!
        _ = try? wss.account.getAccount(byId: id).debug().toBlocking().single()
        wss.core.dispose()
        
        _ = try? wss.account.getAccount(byId: id).debug().toBlocking().single()
        _ = try? wss.account.getAccount(byId: id).debug().toBlocking().single()
        _ = try? wss.account.getAccount(byId: id).debug().toBlocking().single()
        _ = try? wss.account.getAccount(byId: id).debug().toBlocking().single()
        
        wss.core.dispose()
        
        let result = try? wss.account.getAccount(byId: id).debug().toBlocking().single()
        XCTAssertNotNil(result)
    }
    

    
    static var allTests = [
        ("testWebSocketReconnection", testWebSocketReconnection),
        ]
}
