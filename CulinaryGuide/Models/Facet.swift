import UIKit

protocol Facet: Equatable {
    var column: String? { get }
    var value: String? { get }
    var icon: UIImage? { get }
}
