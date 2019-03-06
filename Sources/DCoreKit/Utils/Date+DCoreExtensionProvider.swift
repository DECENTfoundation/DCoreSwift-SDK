import Foundation

extension Date: DCoreExtensionProvider {}

extension DCoreExtension where Base == Date {
    public var description: String {
        return DateFormatter.standard.string(from: self.base)
    }
}
