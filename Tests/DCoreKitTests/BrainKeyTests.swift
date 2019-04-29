import XCTest

@testable import DCoreKit

final class BrainKeyTests: XCTestCase {

    func testGenerateBrainKey() {
        let brainKey = BrainKey.generate(
            withEntropy: "9ebcb35340be50de801d858bd1f0de8ae20d5ee7916acb00de8371c516e8ee6f".unhex()!,
            seedDictionary: englishWordList,
            count: DCore.Constant.brainKeyWordCount)

        XCTAssertEqual(DCore.Constant.brainKeyWordCount, brainKey.words.count)
        XCTAssertEqual(
            "paddle,recall,dolphin,extend,lens,machine,spirit,teach,tilt,galaxy,multiply,slam,teach,impact,black,unveil",
            brainKey.words.joined(separator: ",")
        )
        brainKey.words.forEach { word in
            XCTAssertTrue(englishWordList.contains(word))
            XCTAssertEqual(word, word.lowercased())
        }
    }

    func testGenerateBrainKeyUsingDefaultSeedDictionary() {
        let brainKey = BrainKey.generate()
        
        XCTAssertEqual(DCore.Constant.brainKeyWordCount, brainKey.words.count)
        brainKey.words.forEach { word in
            XCTAssertEqual(word, word.lowercased())
        }
    }

    func testGenerateEcKeyparFromNormalizedBrainKey() {
        let brainKey = BrainKey(words: ["lording", "talar", "zoonal", "pibroch", "muffler", "sorgho", "skirty", "carper", "scrobe", "evens", "esere", "chaute", "acker", "avine", "berhyme", "canions"])
        let expectedPrivateKey = "5J1XV99mVwsd5n6zhwvDV1KnhC17opdxDtnHg3ut57KKVJrGm6m"

        XCTAssertEqual(expectedPrivateKey, try brainKey.asECKeyPair().privateKey.toWif())
    }

    func testGenerateEcKeyparFromBrainKey() {
        let brainKey = BrainKey(words: ["lording", "talar", "zoonal", "pibroch", "muffler", "sorgho", "skirty", "carper", "scrobe", "evens", "esere", "chaute", "acker", "avine", "berhyme", "canions"])
        let expectedPrivateKey = "5J6npTJWXCr4J4pahKdQstvzifgtsNQGgnAayGxK8AV1m9JHcS8"
        
        XCTAssertEqual(expectedPrivateKey, try brainKey.asECKeyPair(normalized: false).privateKey.toWif())
    }
}
