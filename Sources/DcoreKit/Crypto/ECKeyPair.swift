import Foundation
import BigInt

public struct ECKeyPair {

    public let privateKey: BigInt?
    public let compressed: Bool?
    
    public let publicKey: Any
    
    fileprivate init(usingPrivate key: BigInt, public publicKey: Any, compressed: Bool? = nil) {
        self.privateKey = key
    }
}

/*
package ch.decent.sdk.crypto

import ch.decent.sdk.net.serialization.bytes
import ch.decent.sdk.utils.Hex
import org.bouncycastle.asn1.x9.X9IntegerConverter
import org.bouncycastle.crypto.digests.SHA256Digest
import org.bouncycastle.crypto.ec.CustomNamedCurves
import org.bouncycastle.crypto.generators.ECKeyPairGenerator
import org.bouncycastle.crypto.params.ECDomainParameters
import org.bouncycastle.crypto.params.ECKeyGenerationParameters
import org.bouncycastle.crypto.params.ECPrivateKeyParameters
import org.bouncycastle.crypto.signers.ECDSASigner
import org.bouncycastle.crypto.signers.HMacDSAKCalculator
import org.bouncycastle.math.ec.ECAlgorithms
import org.bouncycastle.math.ec.ECPoint
import org.bouncycastle.math.ec.FixedPointCombMultiplier
import org.bouncycastle.math.ec.FixedPointUtil
import org.bouncycastle.math.ec.custom.sec.SecP256K1Curve
import java.math.BigInteger
import java.security.SecureRandom

class ECKeyPair {
    
    val private: BigInteger?
    val compressed: Boolean?
    val public
    get() = lazyPublic.value
    private val lazyPublic: Lazy<ECPoint>
    
    private constructor(private: BigInteger? = null, public: ECPoint?, compressed: Boolean? = null) {
    this.private = private
    this.lazyPublic = if (public != null) lazyOf(public) else lazy { publicPointFromPrivate(private!!) }
    this.compressed = compressed
    }
    
    constructor(secureRandom: SecureRandom) {
    val keyPair = ECKeyPairGenerator().let {
    it.init(ECKeyGenerationParameters(curve, secureRandom))
    it.generateKeyPair()
    }
    private = (keyPair.private as ECPrivateKeyParameters).d
    lazyPublic = lazy { publicPointFromPrivate(private) }
    compressed = true
    }
    
    fun sign(input: Sha256Hash): ECDSASignature {
    checkNotNull(private)
    val key = ECPrivateKeyParameters(private, curve)
    val signer = ECDSASigner(HMacDSAKCalculator(SHA256Digest())).apply { init(true, key) }
    val components = signer.generateSignature(input.bytes)
    return ECDSASignature(components[0], components[1]).toCanonicalised()
    }
    
    /**
     * should be called in a loop until a 'canonical' signature is returned, slightly changing input data on every call
     * @see <a href="https://github.com/steemit/steem/issues/1944">https://github.com/steemit/steem/issues/1944</a>
     */
    fun signature(data: Sha256Hash): String {
    val signature = sign(data)
    var recId = -1
    
    for (i in 0..3) {
    val k = ECKeyPair.recoverFromSignature(i, signature, data)
    if (k != null && k.public.equals(public)) {
    recId = i
    break
    }
    }
    
    if (recId == -1) throw RuntimeException("Could not construct a recoverable keyPair. This should never happen.")
    
    //    the public keyPair is always in a compressed format in DCore
    val headerByte = (recId + headerCompressed).toByte()
    val sigData = ByteArray(65)  // 1 header + 32 bytes for R + 32 bytes for S
    sigData[0] = headerByte
    System.arraycopy(signature.r.bytes(32), 0, sigData, 1, 32)
    System.arraycopy(signature.s.bytes(32), 0, sigData, 33, 32)
    
    //    canonical tests
    return if (sigData[0].toInt() and 0x80 != 0 || sigData[0].toInt() == 0 ||
    sigData[1].toInt() and 0x80 != 0 || sigData[32].toInt() and 0x80 != 0 ||
    sigData[32].toInt() == 0 || sigData[33].toInt() and 0x80 != 0) {
    ""
    } else {
    Hex.encode(sigData)
    }
    }
    
    override fun equals(other: Any?): Boolean {
    if (this === other) return true
    if (javaClass != other?.javaClass) return false
    
    other as ECKeyPair
    
    if (private != other.private) return false
    
    return true
    }
    
    override fun hashCode(): Int {
    return private?.hashCode() ?: 0
    }
    
    companion object {
    private val curveParams = CustomNamedCurves.getByName("secp256k1")
    private val curve: ECDomainParameters
    private val curveHalfOrder: BigInteger
    private const val headerUncompressed = 27
    private const val headerCompressed = 31
    
    init {
    FixedPointUtil.precompute(curveParams.g)
    curve = ECDomainParameters(curveParams.curve, curveParams.g, curveParams.n)
    curveHalfOrder = curveParams.n.shiftRight(1)
    }
    
    @JvmStatic
    fun fromPrivate(key: ByteArray, compressed: Boolean = true): ECKeyPair {
    val private = BigInteger(1, key)
    return ECKeyPair(private, null, compressed)
    }
    
    @JvmStatic
    fun fromBase58(encoded: String): ECKeyPair {
    val dpk = DumpedPrivateKey.fromBase58(encoded)
    return fromPrivate(dpk.bytes, dpk.compressed)
    }
    
    @JvmStatic
    fun fromPublic(key: ByteArray): ECKeyPair = ECKeyPair(public = curve.curve.decodePoint(key))
    
    @JvmStatic
    fun fromPublic(point: ECPoint): ECKeyPair = ECKeyPair(public = point)
    
    /**
     * Returns public keyPair point from the given private keyPair. To convert a byte array into a BigInteger, use <tt>
     * new BigInteger(1, bytes);</tt>
     
     * TODO: FixedPointCombMultiplier currently doesn't support scalars longer than the group order, but that could change in future versions.
     */
    private fun publicPointFromPrivate(key: BigInteger): ECPoint =
    FixedPointCombMultiplier().multiply(curve.g, if (key.bitLength() > curve.n.bitLength()) key.mod(curve.n) else key)
    
    /**
     * Given the components of a signature and a selector value, recover and return the public keyPair
     * that generated the signature according to the algorithm in SEC1v2 section 4.1.6.
     *
     * The recId is an index from 0 to 3 which indicates which of the 4 possible keys is the correct one. Because
     * the keyPair recovery operation yields multiple potential keys, the correct keyPair must either be stored alongside the
     * signature, or you must be willing to try each recId in turn until you find one that outputs the keyPair you are
     * expecting.
     *
     * If this method returns null it means recovery was not possible and recId should be iterated.
     *
     * Given the above two points, a correct usage of this method is inside a for loop from 0 to 3, and if the
     * output is null OR a keyPair that is not the one you expect, you try again with the next recId.
     *
     * @param recId Which possible keyPair to recover.
     * @param sig the R and S components of the signature, wrapped.
     * @param message Hash of the data that was signed.
     * @return An ECKeyPair containing only the public part, or null if recovery wasn't possible.
     */
    @JvmStatic
    fun recoverFromSignature(recId: Int, sig: ECDSASignature, message: Sha256Hash): ECKeyPair? {
    require(recId >= 0, { "recId must be positive" })
    require(sig.r.signum() >= 0, { "r must be positive" })
    require(sig.s.signum() >= 0, { "s must be positive" })
    requireNotNull(message)
    // 1.0 For j from 0 to h   (h == recId here and the loop is outside this function)
    //   1.1 Let x = r + jn
    val n = curve.n  // Curve order.
    val i = BigInteger.valueOf(recId.toLong() / 2)
    val x = sig.r.add(i.multiply(n))
    //   1.2. Convert the integer x to an octet string X of length mlen using the conversion routine
    //        specified in Section 2.3.7, where mlen = ⌈(log2 p)/8⌉ or mlen = ⌈m/8⌉.
    //   1.3. Convert the octet string (16 set binary digits)||X to an elliptic curve point R using the
    //        conversion routine specified in Section 2.3.4. If this conversion routine outputs “invalid”, then
    //        do another iteration of Step 1.
    //
    // More concisely, what these points mean is to use X as a compressed public keyPair.
    val prime = SecP256K1Curve.q
    if (x >= prime) {
    // Cannot have point co-ordinates larger than this as everything takes place modulo Q.
    return null
    }
    // Compressed keys require you to know an extra bit of data about the y-coord as there are two possibilities.
    // So it's encoded in the recId.
    val R = decompressKey(x, recId and 1 == 1)
    //   1.4. If nR != point at infinity, then do another iteration of Step 1 (callers responsibility).
    if (!R.multiply(n).isInfinity)
    return null
    //   1.5. Compute e from M using Steps 2 and 3 of ECDSA signature verification.
    val e = message.toBigInteger()
    //   1.6. For k from 1 to 2 do the following.   (loop is outside this function via iterating recId)
    //   1.6.1. Compute a candidate public keyPair as:
    //               Q = mi(r) * (sR - eG)
    //
    // Where mi(x) is the modular multiplicative inverse. We transform this into the following:
    //               Q = (mi(r) * s ** R) + (mi(r) * -e ** G)
    // Where -e is the modular additive inverse of e, that is z such that z + e = 0 (mod n). In the above equation
    // ** is point multiplication and + is point addition (the EC group operator).
    //
    // We can find the additive inverse by subtracting e from zero then taking the mod. For example the additive
    // inverse of 3 modulo 11 is 8 because 3 + 8 mod 11 = 0, and -3 mod 11 = 8.
    val eInv = BigInteger.ZERO.subtract(e).mod(n)
    val rInv = sig.r.modInverse(n)
    val srInv = rInv.multiply(sig.s).mod(n)
    val eInvrInv = rInv.multiply(eInv).mod(n)
    val q = ECAlgorithms.sumOfTwoMultiplies(curve.g, eInvrInv, R, srInv)
    return ECKeyPair.fromPublic(q)
    }
    
    /** Decompress a compressed public keyPair (x co-ord and low-bit of y-coord).  */
    private fun decompressKey(xBN: BigInteger, yBit: Boolean): ECPoint {
    val x9 = X9IntegerConverter()
    val compEnc = x9.integerToBytes(xBN, 1 + x9.getByteLength(curve.curve))
    compEnc[0] = (if (yBit) 0x03 else 0x02).toByte()
    return curve.curve.decodePoint(compEnc)
    }
    }
    
    data class ECDSASignature(val r: BigInteger, val s: BigInteger) {
    
    /**
     * Returns true if the S component is "low", that means it is below [ECKeyPair.HALF_CURVE_ORDER].
     * See [BIP62](https://github.com/bitcoin/bips/blob/master/bip-0062.mediawiki#Low_S_values_in_signatures).
     */
    val isCanonical: Boolean
    get() = s <= curveHalfOrder
    
    /**
     * Will automatically adjust the S component to be less than or equal to half the curve order, if necessary.
     * This is required because for every signature (r,s) the signature (r, -s (mod N)) is a valid signature of
     * the same message. However, we dislike the ability to modify the bits of a Bitcoin transaction after it's
     * been signed, as that violates various assumed invariants. Thus in future only one of those forms will be
     * considered legal and the other will be banned.
     */
    fun toCanonicalised(): ECDSASignature = if (!isCanonical) {
    // The order of the curve is the number of valid points that exist on that curve. If S is in the upper
    // half of the number of valid points, then bring it back to the lower half. Otherwise, imagine that
    //    N = 10
    //    s = 8, so (-8 % 10 == 2) thus both (r, 8) and (r, 2) are valid solutions.
    //    10 - 8 == 2, giving us always the latter solution, which is canonical.
    ECDSASignature(r, curve.n.subtract(s))
    } else {
    this
    }
    
    }
    
}

fun DumpedPrivateKey.ecKey() = ECKeyPair.fromPrivate(bytes, compressed)
fun ECKeyPair.base58() = this.dpk().toString()
fun ECKeyPair.dpk() = DumpedPrivateKey(this)
fun ECKeyPair.address() = this.public.address()
*/
