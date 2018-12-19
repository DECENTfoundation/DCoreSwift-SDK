import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(CryptoTests.allTests),
        testCase(SerializationTests.allTests),
    ]
}
#endif
