import XCTest
import RxSwift
import RxBlocking

@testable import DCoreKit

class BlockApiTests: XCTestCase {
    
    private let rest = DCore.Sdk.create(forRest: "https://stagesocket.decentgo.com:8090/rpc")
    
    func testGetBlockHeaderUsingRest() {
        let num: UInt64 = 1000
        
        let result = try? rest.block.getBlockHeader(byNum: num).debug().toBlocking().single()
        XCTAssertEqual(result?.num, num)
    }
    
    
    
    
    static var allTests = [
        ("testGetBlockHeaderUsingRest", testGetBlockHeaderUsingRest),
        ]
}
