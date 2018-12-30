import Foundation

public protocol LoggerConvertible {
    static func verbose(_ message: String)
    static func info(_ message: String)
    static func warning(_ message: String)
    static func error(_ message: String)
    static func debug(_ message: String)
}

extension LoggerConvertible {
    public static func verbose(_ message: String) {
        print(message)
    }
    
    public static func info(_ message: String) {
        print(message)
    }
    
    public static func warning(_ message: String) {
        print(message)
    }
    
    public static func error(_ message: String) {
        print(message)
    }
    
    public static func debug(_ message: String) {
        print(message)
    }
}
