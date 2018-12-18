import Foundation

extension Encodable {
    func toJson() throws -> String? {
        return String(data: try JSONEncoder().encode(self), encoding: .utf8)
    }
}
