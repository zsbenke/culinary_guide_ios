import UIKit

protocol HomeScreenSection: CustomStringConvertible {}

protocol Facet {
    var column: String? { get }
    var value: String? { get }
    var icon: UIImage? { get }
}
