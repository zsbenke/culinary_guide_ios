import Foundation

extension Array where Element : Equatable {
    mutating func remove(_ element: Element) {
        guard let indexOfElement = index(of: element) else { return }
        remove(at: indexOfElement)
    }
}
