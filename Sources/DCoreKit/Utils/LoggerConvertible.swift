import Foundation
import os.log

extension DCore {
    public enum Logger: LoggerConvertible {}
}

@available(OSX 10.14, iOS 12.0, watchOS 3.0, tvOS 10.0, *)
fileprivate enum LoggerDefaults {
    static let network = OSLog(subsystem: DCore.namespace, category: "Network")
    static let chain = OSLog(subsystem: DCore.namespace, category: "Chain")
    static let crypto = OSLog(subsystem: DCore.namespace, category: "Crypto")
}

public protocol LoggerConvertible {
    static func debug(network message: StaticString, args: (() -> CVarArg?)?)
    static func debug(chain message: StaticString, args: (() -> CVarArg?)?)
    static func debug(crypto message: StaticString, args: (() -> CVarArg?)?)
    
    static func info(_ log: OSLog, message: StaticString, args: (() -> CVarArg?)?)
    static func debug(_ log: OSLog, message: StaticString, args: (() -> CVarArg?)?)
    static func error(_ log: OSLog, message: StaticString, args: (() -> CVarArg?)?)
    static func fault(_ log: OSLog, message: StaticString, args: (() -> CVarArg?)?)
    
}

extension LoggerConvertible {
    public static func info(_ log: OSLog, message: StaticString, args: (() -> CVarArg?)? = nil) {
        if #available(OSX 10.14, iOS 12.0, watchOS 3.0, tvOS 10.0, *) {
            if let args = args, let value = args() {
                os_log(.info, log: log, message, value)
            } else {
                os_log(.info, log: log, message)
            }
        }
    }
    
    public static func debug(_ log: OSLog, message: StaticString, args: (() -> CVarArg?)? = nil) {
        if #available(OSX 10.14, iOS 12.0, watchOS 3.0, tvOS 10.0, *) {
            if let args = args, let value = args() {
                os_log(.debug, log: log, message, value)
            } else {
                os_log(.debug, log: log, message)
            }
        }
    }
    
    public static func error(_ log: OSLog, message: StaticString, args: (() -> CVarArg?)? = nil) {
        if #available(OSX 10.14, iOS 12.0, watchOS 3.0, tvOS 10.0, *) {
            if let args = args, let value = args() {
                os_log(.error, log: log, message, value)
            } else {
                os_log(.error, log: log, message)
            }
        }
    }
    
    public static func fault(_ log: OSLog, message: StaticString, args: (() -> CVarArg?)? = nil) {
        if #available(OSX 10.14, iOS 12.0, watchOS 3.0, tvOS 10.0, *) {
            if let args = args, let value = args() {
                os_log(.fault, log: log, message, value)
            } else {
                os_log(.fault, log: log, message)
            }
        }
    }
    
    public static func debug(network message: StaticString, args: (() -> CVarArg?)? = nil) {
        if #available(OSX 10.14, iOS 12.0, watchOS 3.0, tvOS 10.0, *) {
            debug(LoggerDefaults.network, message: message, args: args)
        }
    }
    
    public static func debug(chain message: StaticString, args: (() -> CVarArg?)? = nil) {
        if #available(OSX 10.14, iOS 12.0, watchOS 3.0, tvOS 10.0, *) {
            debug(LoggerDefaults.chain, message: message, args: args)
        }
    }
    
    public static func debug(crypto message: StaticString, args: (() -> CVarArg?)? = nil) {
        if #available(OSX 10.14, iOS 12.0, watchOS 3.0, tvOS 10.0, *) {
            debug(LoggerDefaults.crypto, message: message, args: args)
        }
    }
}
