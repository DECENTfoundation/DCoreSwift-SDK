import Foundation

extension DateFormatter {
    static var standard: DateFormatter {

        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        format.timeZone = TimeZone(abbreviation: "UTC")

        return format
    }
}
