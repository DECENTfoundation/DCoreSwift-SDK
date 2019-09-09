import Foundation

extension Date: DCoreExtensionProvider {}

extension DCoreExtension where Base == Date {
    public var description: String {
        return DateFormatter.standard.string(from: self.base)
    }

    public static func date(from date: String) -> Date? {
        return DateFormatter.standard.date(from: date)
    }
}
