import Foundation
import os.log

private var consoleLevels: Set<OSLogType> = Set<OSLogType>()
private var consoleCategories: Set<LoggerCategory> = Set<LoggerCategory>()

public enum LoggerCategory: String {
    case
    network = "Network",
    chain = "Chain",
    crypto = "Crypto"
}

extension OSLogType: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.rawValue)
    }
}

extension DCore {
    public enum Logger: LoggerConvertible {}
}

@available(OSX 10.14, iOS 12.0, watchOS 3.0, tvOS 10.0, *)
fileprivate enum LoggerDefaults {
    static let network = OSLog(subsystem: DCore.namespace, category: LoggerCategory.network.rawValue)
    static let chain = OSLog(subsystem: DCore.namespace, category: LoggerCategory.chain.rawValue)
    static let crypto = OSLog(subsystem: DCore.namespace, category: LoggerCategory.crypto.rawValue)
}

public protocol LoggerConvertible {
    static func xcode(filterLevels levels: [OSLogType])
    static func xcode(filterCategories categories: [LoggerCategory])
    
    static func debug(network message: StaticString, args: (() -> CVarArg?)?)
    static func debug(chain message: StaticString, args: (() -> CVarArg?)?)
    static func debug(crypto message: StaticString, args: (() -> CVarArg?)?)
    
    static func error(network message: StaticString, args: (() -> CVarArg?)?)
    static func error(chain message: StaticString, args: (() -> CVarArg?)?)
    static func error(crypto message: StaticString, args: (() -> CVarArg?)?)
    
    static func info(_ log: OSLog, message: StaticString, args: (() -> CVarArg?)?, category: LoggerCategory?)
    static func debug(_ log: OSLog, message: StaticString, args: (() -> CVarArg?)?, category: LoggerCategory?)
    static func error(_ log: OSLog, message: StaticString, args: (() -> CVarArg?)?, category: LoggerCategory?)
    static func fault(_ log: OSLog, message: StaticString, args: (() -> CVarArg?)?, category: LoggerCategory?)
}

extension LoggerConvertible {
    public static func xcode(filterLevels levels: [OSLogType]) {
        consoleLevels = Set(levels)
    }
    
    public static func xcode(filterCategories categories: [LoggerCategory]) {
        consoleCategories = Set(categories)
    }
    
    public static func info(_ log: OSLog, message: StaticString, args: (() -> CVarArg?)? = nil, category: LoggerCategory? = nil) {
        if #available(OSX 10.14, iOS 12.0, watchOS 3.0, tvOS 10.0, *) {
            guard log.isEnabled(type: .info) else { return }
            guard consoleLevels.isEmpty || consoleLevels.contains(.info) else { return }
            guard consoleCategories.isEmpty || category.isNil() || consoleCategories.contains(category!) else { return }
            
            if let args = args, let value = args() {
                os_log(.info, log: log, message, value)
            } else {
                os_log(.info, log: log, message)
            }
        }
    }
    
    public static func debug(_ log: OSLog, message: StaticString, args: (() -> CVarArg?)? = nil, category: LoggerCategory? = nil) {
        if #available(OSX 10.14, iOS 12.0, watchOS 3.0, tvOS 10.0, *) {
            guard log.isEnabled(type: .debug) else { return }
            guard consoleLevels.isEmpty || consoleLevels.contains(.debug) else { return }
            guard consoleCategories.isEmpty || category.isNil() || consoleCategories.contains(category!) else { return }
            
            if let args = args, let value = args() {
                os_log(.debug, log: log, message, value)
            } else {
                os_log(.debug, log: log, message)
            }
        }
    }
    
    public static func error(_ log: OSLog, message: StaticString, args: (() -> CVarArg?)? = nil, category: LoggerCategory? = nil) {
        if #available(OSX 10.14, iOS 12.0, watchOS 3.0, tvOS 10.0, *) {
            guard log.isEnabled(type: .error) else { return }
            guard consoleLevels.isEmpty || consoleLevels.contains(.error) else { return }
            guard consoleCategories.isEmpty || category.isNil() || consoleCategories.contains(category!) else { return }
            
            if let args = args, let value = args() {
                os_log(.error, log: log, message, value)
            } else {
                os_log(.error, log: log, message)
            }
        }
    }
    
    public static func fault(_ log: OSLog, message: StaticString, args: (() -> CVarArg?)? = nil, category: LoggerCategory? = nil) {
        if #available(OSX 10.14, iOS 12.0, watchOS 3.0, tvOS 10.0, *) {
            guard log.isEnabled(type: .fault) else { return }
            guard consoleLevels.isEmpty || consoleLevels.contains(.fault) else { return }
            guard consoleCategories.isEmpty || category.isNil() || consoleCategories.contains(category!) else { return }
            
            if let args = args, let value = args() {
                os_log(.fault, log: log, message, value)
            } else {
                os_log(.fault, log: log, message)
            }
        }
    }
    
    public static func debug(network message: StaticString, args: (() -> CVarArg?)? = nil) {
        if #available(OSX 10.14, iOS 12.0, watchOS 3.0, tvOS 10.0, *) {
            debug(LoggerDefaults.network, message: message, args: args, category: .network)
        }
    }
    
    public static func debug(chain message: StaticString, args: (() -> CVarArg?)? = nil) {
        if #available(OSX 10.14, iOS 12.0, watchOS 3.0, tvOS 10.0, *) {
            debug(LoggerDefaults.chain, message: message, args: args, category: .chain)
        }
    }
    
    public static func debug(crypto message: StaticString, args: (() -> CVarArg?)? = nil) {
        if #available(OSX 10.14, iOS 12.0, watchOS 3.0, tvOS 10.0, *) {
            debug(LoggerDefaults.crypto, message: message, args: args, category: .crypto)
        }
    }
    
    public static func error(network message: StaticString, args: (() -> CVarArg?)? = nil) {
        if #available(OSX 10.14, iOS 12.0, watchOS 3.0, tvOS 10.0, *) {
            error(LoggerDefaults.network, message: message, args: args, category: .network)
        }
    }
    
    public static func error(chain message: StaticString, args: (() -> CVarArg?)? = nil) {
        if #available(OSX 10.14, iOS 12.0, watchOS 3.0, tvOS 10.0, *) {
            error(LoggerDefaults.chain, message: message, args: args, category: .chain)
        }
    }
    
    public static func error(crypto message: StaticString, args: (() -> CVarArg?)? = nil) {
        if #available(OSX 10.14, iOS 12.0, watchOS 3.0, tvOS 10.0, *) {
            error(LoggerDefaults.crypto, message: message, args: args, category: .crypto)
        }
    }
}
