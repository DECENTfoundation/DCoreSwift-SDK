import Foundation
import BigInt

public struct Memo: Codable {
    
    public let from: Address?
    public let to: Address?
    public let message: String
    public let nonce: BigInt
    
    private enum CodingKeys: String, CodingKey {
        case
        from,
        to,
        message,
        nonce
    }
    
    public init(usingMessage msg: String) {
        message = "" //(ByteArray(4, { 0 }) + message.toByteArray()).hex()
        nonce = BigInt(0)
    }
    
    public init(usingMessage msg: String, keyPair: ECKeyPair, recipient: Address, nonce: BigInt) {
        guard nonce.signum() > 0 else { preconditionFailure("nonce must be a positive number") }
        
        self.nonce = nonce
        self.from = Address(keyPair.public)
        self.to = recipient
    }
}

/*
class Memo : ByteSerializable {
    @SerializedName("from") val from: Address?
    @SerializedName("to") val to: Address?
    @SerializedName("message") val message: String
    @SerializedName("nonce") val nonce: BigInteger
    
    constructor(message: String) {
    this.message = (ByteArray(4, { 0 }) + message.toByteArray()).hex()
    this.nonce = BigInteger.ZERO
    this.from = null
    this.to = null
    }
    
    constructor(message: String, keyPair: ECKeyPair, recipient: Address, nonce: BigInteger = generateNonce()) {
    require(nonce.signum() > 0, { "nonce must be a positive number" })
    this.nonce = nonce
    this.from = Address(keyPair.public)
    this.to = recipient
    val checksummed = Sha256Hash.hash(message.toByteArray()).copyOfRange(0, 4) + message.toByteArray()
    val secret = keyPair.secret(recipient, this.nonce)
    this.message = encryptAes(secret, checksummed).hex()
    }
    
    private fun decryptOrEmpty(secret: ByteArray) = try {
    decryptAesWithChecksum(secret, message.unhex())
    } catch (ex: Exception) {
    ""
    }
    
    override val bytes: ByteArray
    get() = Bytes.concat(
    from.bytes(),
    to.bytes(),
    nonce.toLong().bytes(),
    message.unhex().bytes()
    )
    
    fun decrypt(keyPair: ECKeyPair): String {
    return if (from == null || to == null) {
    message.drop(8).unhex().toString(Charset.forName("UTF-8"))
    } else if (from.publicKey == keyPair.public) {
    decryptOrEmpty(keyPair.secret(to, nonce))
    } else if (to.publicKey == keyPair.public) {
    decryptOrEmpty(keyPair.secret(from, nonce))
    } else {
    ""
    }
    }
    
    override fun toString(): String {
    return "Memo(from=$from, to=$to, message='$message', nonce=$nonce)"
    }
}*/
