import UIKit

protocol Rating {
    var points: String { get set }
    var image: UIImage { get }
    var color: UIColor { get }
    var isSecondary: Bool { get }
}
