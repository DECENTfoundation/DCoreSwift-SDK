import Foundation

extension Array {
    func partitionSplit(by belongsInSecondPartition: (Element) throws -> Bool) rethrows -> ([Element], [Element]) {
        var elements = self
        let idx = try elements.partition(by: belongsInSecondPartition)

        return (Array(elements[idx...]), Array(elements[..<idx]))
    }
}
