import XCTest

@testable import DCoreKit

final class BrainKeyTests: XCTestCase {

    func testGenerateBrainKey() {
        let brainKey = BrainKey.generate(
            withEntropy: "9ebcb35340be50de801d858bd1f0de8ae20d5ee7916acb00de8371c516e8ee6f".unhex()!,
            seedDictionary: EnglishWordList,
            count: DCore.Constant.brainKeyWordCount)

        XCTAssertEqual(DCore.Constant.brainKeyWordCount, brainKey.words.count)
        brainKey.words.forEach { word in
            XCTAssertTrue(EnglishWordList.contains(word))
            XCTAssertEqual(word, word.lowercased())
        }
    }

}
