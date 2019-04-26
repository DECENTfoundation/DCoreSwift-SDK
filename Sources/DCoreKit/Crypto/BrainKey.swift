import Foundation

public struct BrainKey: Equatable {
    public let words: [String]

    public static func generate(
        seedDictionary: [String], count: Int = DCore.Constant.brainKeyWordCount) throws -> BrainKey {
        return generate(
            withEntropy: CryptoUtils.secureRandom(), seedDictionary: seedDictionary, count: count)
    }

    static func generate(withEntropy entropy: Data, seedDictionary: [String], count: Int) -> BrainKey {
        var words = [String]()
        for iteration in stride(from: 0, to: count * 2, by: 2) {
            // entropy buffer has 256 bits / 16 bits per word == 16 words
            let num = (UInt64(entropy[iteration]) << 8) + UInt64(entropy[iteration + 1])
            
            // convert into a int between 0 and 1 (inclusive)
            let multiplier = Double(num) / pow(2.0, 16.0)
            let index = abs(round(Double(seedDictionary.count) * multiplier))

            words.append(seedDictionary[Int(index)])
        }

        return BrainKey(words: words)
    }
}
