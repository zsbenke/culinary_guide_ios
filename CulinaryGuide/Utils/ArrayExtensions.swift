import Foundation

extension Array where Element : Equatable {
    mutating func remove(_ element: Element) {
        guard let indexOfElement = index(of: element) else { return }
        remove(at: indexOfElement)
    }
}

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}
