@testable import DCoreKit

struct Kitten: NftModel {
    var male: Bool = false
    @NftProperty(modifiableBy: .issuer) var name: String = ""
    var weight: Int = 0
    @NftProperty(unique: true, modifiableBy: .both) var owner: String = ""
}

struct Puppy: NftModel {
    var male: Bool = false
    @NftProperty(modifiableBy: .owner) var name: String = ""
    var weight: Int = 0
    @NftProperty(unique: true, modifiableBy: .both) var owner: String = ""
}
