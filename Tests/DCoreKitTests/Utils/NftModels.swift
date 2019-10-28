@testable import DCoreKit

public struct Kitten: NftModel {
    var male: Bool = false
    @NftProperty(modifiableBy: .issuer) var name: String = ""
    var weight: Int = 0
    @NftProperty(unique: true, modifiableBy: .both) var owner: String = ""

    public init() {}

    public init(
        male: Bool = false,
        name: String = "",
        weight: Int = 0,
        owner: String = ""
    ) {
        self.male = male
        self.name = name
        self.weight = weight
        self.owner = owner
    }
}

public struct Puppy: NftModel {
    var male: Bool = false
    @NftProperty(modifiableBy: .owner) var name: String = ""
    var weight: Int = 0
    @NftProperty(unique: true, modifiableBy: .both) var owner: String = ""

    public init() {}

    public init(
        male: Bool = false,
        name: String = "",
        weight: Int = 0,
        owner: String = ""
    ) {
        self.male = male
        self.name = name
        self.weight = weight
        self.owner = owner
    }
}
