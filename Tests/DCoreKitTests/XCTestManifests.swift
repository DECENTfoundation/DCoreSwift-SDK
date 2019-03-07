import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AccountApiTests.allTests),
        testCase(AccountApiMockTests.allTests),
        testCase(BalanceApiTests.allTests),
        testCase(OperationApiTests.allTests),
        testCase(GeneralApiTests.allTests),
        testCase(AssetApiTests.allTests),
        testCase(SubscriptionApiTests.allTests),
        testCase(CryptoTests.allTests),
        testCase(SerializationTests.allTests),
        testCase(ValidationApiTests.allTests),
        testCase(BlockApiTests.allTests),
        testCase(SecurityTests.allTest),
    ]
}
#endif
