import XCTest

@testable import DCoreKit

class QrTransferTests: XCTestCase {
    private let memo = "some weird test text = and so on % with special chars"
    private let urlEncodedMemo = "some%20weird%20test%20text%20%3D%20and%20so%20on%20%25%20with%20special%20chars"

    func testInputToQrString() {
        XCTAssertEqual(
            "decent:abc?amount=&asset=&memo=",
            QrTransfer(accountName: "abc").toQrString()
        )

        XCTAssertEqual(
            "decent:abc?amount=&asset=DCT&memo=\(urlEncodedMemo)",
            QrTransfer(accountName: "abc", assetSymbol: "DCT", amount: "", memo: memo).toQrString()
        )

        XCTAssertEqual(
            "decent:abc?amount=1.2&asset=DCT&memo=\(urlEncodedMemo)",
            QrTransfer(accountName: "abc", assetSymbol: "DCT", amount: "1.2", memo: memo).toQrString()
        )
    }

    func testQrStringToQrTransfer() {
        let input = "decent:abc?amount=1.2&asset=DCT&memo=some%20weird%20test%20text%20%3D%20and%20so%20on%20%25%20with%20special%20chars"

        XCTAssertEqual(
            input.asQrTransfer(),
            QrTransfer(
                accountName: "abc",
                assetSymbol: "DCT",
                amount: "1.2",
                memo: "some weird test text = and so on % with special chars"
            )
        )
    }

    static var allTests = [
        ("testInputToQrString", testInputToQrString),
    ]
}
