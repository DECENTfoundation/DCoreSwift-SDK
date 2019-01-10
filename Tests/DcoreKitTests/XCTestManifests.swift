import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AccountApiTests.allTests),
        testCase(BalanceApiTests.allTests),
        testCase(AssetApiTests.allTests),
        testCase(CryptoTests.allTests),
        testCase(SerializationTests.allTests),
    ]
}
#endif
