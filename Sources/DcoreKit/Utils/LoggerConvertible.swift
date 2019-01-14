import Foundation
import os.log

enum Logger: LoggerConvertible {}

@available(OSX 10.14, iOS 12.0, watchOS 3.0, tvOS 10.0, *)
fileprivate enum LoggerDefaults {
    static let network = OSLog(subsystem: "ch.decent.DcoreKit", category: "Network")
    static let chain = OSLog(subsystem: "ch.decent.DcoreKit", category: "Chain")
    static let crypto = OSLog(subsystem: "ch.decent.DcoreKit", category: "Crypto")
}

protocol LoggerConvertible {
    
    static func debug(network message: StaticString, args: (() -> CVarArg?)?)
    static func debug(chain message: StaticString, args: (() -> CVarArg?)?)
    static func debug(crypto message: StaticString, args: (() -> CVarArg?)?)
    
    static func info(_ log: OSLog, message: StaticString, args: (() -> CVarArg?)?)
    static func debug(_ log: OSLog, message: StaticString, args: (() -> CVarArg?)?)
    static func error(_ log: OSLog, message: StaticString, args: (() -> CVarArg?)?)
    static func fault(_ log: OSLog, message: StaticString, args: (() -> CVarArg?)?)
    
}

extension LoggerConvertible {
    
    static func info(_ log: OSLog, message: StaticString, args: (() -> CVarArg?)? = nil) {
        if #available(OSX 10.14, iOS 12.0, watchOS 3.0, tvOS 10.0, *) {
            if let args = args, let value = args() {
                os_log(.info, log: log, message, value)
            } else {
                os_log(.info, log: log, message)
            }
        }
    }
    
    static func debug(_ log: OSLog, message: StaticString, args: (() -> CVarArg?)? = nil) {
        if #available(OSX 10.14, iOS 12.0, watchOS 3.0, tvOS 10.0, *) {
            if let args = args, let value = args() {
                os_log(.debug, log: log, message, value)
            } else {
                os_log(.debug, log: log, message)
            }
        }
    }
    
    static func error(_ log: OSLog, message: StaticString, args: (() -> CVarArg?)? = nil) {
        if #available(OSX 10.14, iOS 12.0, watchOS 3.0, tvOS 10.0, *) {
            if let args = args, let value = args() {
                os_log(.error, log: log, message, value)
            } else {
                os_log(.error, log: log, message)
            }
        }
    }
    
    static func fault(_ log: OSLog, message: StaticString, args: (() -> CVarArg?)? = nil) {
        if #available(OSX 10.14, iOS 12.0, watchOS 3.0, tvOS 10.0, *) {
            if let args = args, let value = args() {
                os_log(.fault, log: log, message, value)
            } else {
                os_log(.fault, log: log, message)
            }
        }
    }
    
    static func debug(network message: StaticString, args: (() -> CVarArg?)? = nil) {
        if #available(OSX 10.14, iOS 12.0, watchOS 3.0, tvOS 10.0, *) {
            debug(LoggerDefaults.network, message: message, args: args)
        }
    }
    
    static func debug(chain message: StaticString, args: (() -> CVarArg?)? = nil) {
        if #available(OSX 10.14, iOS 12.0, watchOS 3.0, tvOS 10.0, *) {
            debug(LoggerDefaults.chain, message: message, args: args)
        }
    }
    
    static func debug(crypto message: StaticString, args: (() -> CVarArg?)? = nil) {
        if #available(OSX 10.14, iOS 12.0, watchOS 3.0, tvOS 10.0, *) {
            debug(LoggerDefaults.crypto, message: message, args: args)
        }
        
    }
}
