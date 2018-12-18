import Foundation

public enum CryptoError: Error {
    case
    invalidFormat,
    invalidChecksum,
    signFailed,
    parseFailed,
    noEnoughSpace
}
