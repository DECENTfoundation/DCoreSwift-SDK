import XCTest
import RxSwift
import RxBlocking

@testable import DCoreKit

class BlockApiTests: XCTestCase {
    
    private let rest = DCore.Sdk.create(forRest: DCore.TestConstant.httpUrl)
    
    func testGetBlockHeaderUsingRest() {
        let num: UInt64 = 1
        
        let result = try? rest.block.getHeader(byNum: num).debug().toBlocking().single()
        XCTAssertEqual(result?.num, num)
    }
    
    func testGetBlockUsingRest() {
        let num: UInt64 = 1
        
        let result = try? rest.block.get(byNum: num).toBlocking().single()
        XCTAssertNotNil(result)
    }
    
    static var allTests = [
        ("testGetBlockHeaderUsingRest", testGetBlockHeaderUsingRest),
        ("testGetBlockUsingRest", testGetBlockUsingRest),
        ]
}
