import Foundation

public struct BrainKey: Equatable {
    public let words: [String]

    public init(words: [String]) {
        self.words = words
    }

    /**
     Generates random `BrainKey` using default seed dictionary of words.

     - Parameter count: Number of words to put into generated `BrainKey`.

     - Returns: `BrainKey` consisting of random words.
     */
    public static func generate(count: Int = DCore.Constant.brainKeyWordCount) -> BrainKey {
        return generate(usingSeedDictionary: loadDefaultSeedDictionary(), count: count)
    }

    /**
     Generates random `BrainKey` from provided dictionary of words.
     
     - Parameter seedDictionary: Dictionary of words to use to generate brain key.
     - Parameter count: Number of words to put into generated `BrainKey`.

     - Returns: `BrainKey` consisting of random words.
     */
    public static func generate(
        usingSeedDictionary seedDictionary: [String],
        count: Int = DCore.Constant.brainKeyWordCount) -> BrainKey {
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
            let index = round(Double(seedDictionary.count) * multiplier)

            words.append(seedDictionary[Int(index)])
        }

        return BrainKey(words: words)
    }

    private static func loadDefaultSeedDictionary() -> [String] {
        guard let dictionaryPath = Bundle(for: DCore.Api.self).path(forResource: "SeedDictionary", ofType: "txt") else {
            preconditionFailure("Failed to load brain key seed dictionary")
        }

        let seedDictionary: [String]
        do {
            let fileContent = try String(contentsOfFile: dictionaryPath, encoding: .utf8)
            seedDictionary = fileContent.components(separatedBy: ",")
        } catch {
            preconditionFailure("Failed to load brain key seed dictionary: \(error)")
        }
        return seedDictionary
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .map { $0.replacingOccurrences(of: "\"", with: "") }
            .filter { !$0.isEmpty }
    }
}

extension BrainKey: ECKeyPairConvertible {
    public func asECKeyPair() throws -> ECKeyPair {
        return try asECKeyPair(normalized: true, sequence: 0)
    }

    /**
     Converts `BrainKey` to `ECKeyPair`
     
     - Parameter normalized: Normalized brain key will be uppercased prior to generating key pair.
     - Parameter sequence: Sequence number to be used to generate the key pair.
     
     - Returns: `ECKeyPair`.
     */
    public func asECKeyPair(normalized: Bool = true, sequence: Int = 0) throws -> ECKeyPair {
        let wordsJoined = words.joined(separator: " ")
        let phrase = normalized ? wordsJoined.uppercased() : wordsJoined
        let hash = CryptoUtils.hash256(CryptoUtils.hash512("\(phrase) \(sequence)".asEncoded()))
        return ECKeyPair(fromPrivateKey: PrivateKey(data: hash, compressed: false))
    }
}
