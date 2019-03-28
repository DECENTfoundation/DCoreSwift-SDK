import XCTest
import RxSwift
import RxBlocking

@testable import DCoreKit

class ConnectivityTests: XCTestCase {
    
    private let wss = DCore.Sdk.create(forWss: "wss://api.decent.ch")
    
    func testWebSocketReconnection() {
        let id = "1.2.11368".dcore.chainObject!
        _ = try? wss.account.get(byId: id).debug().toBlocking().single()
        wss.core.dispose()
        
        _ = try? wss.account.get(byId: id).debug().toBlocking().single()
        _ = try? wss.account.get(byId: id).debug().toBlocking().single()
        _ = try? wss.account.get(byId: id).debug().toBlocking().single()
        _ = try? wss.account.get(byId: id).debug().toBlocking().single()
        
        wss.core.dispose()
        
        let result = try? wss.account.get(byId: id).debug().toBlocking().single()
        XCTAssertNotNil(result)
    }
    
    func testURLConvertible() {
        let ipfs = "ipfs:34890231809481209349029ds9ac9csd8908cx9z0c809xzc89z0x"
        let result = ipfs.asURL()?.absoluteString
        XCTAssertTrue(result == ipfs)
    }

    
    static var allTests = [
        ("testWebSocketReconnection", testWebSocketReconnection),
        ("testURLConvertible", testURLConvertible),
        ]
}
