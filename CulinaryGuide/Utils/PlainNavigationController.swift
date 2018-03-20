import UIKit

class PlainNavigationViewController: UINavigationController {
    enum NavigationBarState {
        case `default`
        case transparent
    }

    private let emptyImage = UIImage()
    private let whiteImage = UIImage.fromColor(.white)

    var state: NavigationBarState = .default {
        didSet {
            switch state {
            case .default:
                UIApplication.shared.statusBarStyle = .default

                navigationBar.setBackgroundImage(nil, for: .default)
                navigationBar.shadowImage = emptyImage
                navigationBar.barTintColor = .white
                navigationBar.tintColor = UIColor.BrandColor.primary

                toolbar.setBackgroundImage(nil, forToolbarPosition: .any, barMetrics: .default)
                toolbar.setShadowImage(emptyImage, forToolbarPosition: .any)
                toolbar.barTintColor = .white
                toolbar.tintColor = UIColor.BrandColor.primary
            case .transparent:
                UIApplication.shared.statusBarStyle = .lightContent

                navigationBar.setBackgroundImage(emptyImage, for: .default)
                navigationBar.shadowImage = emptyImage
                navigationBar.barTintColor = nil
                navigationBar.tintColor = .white
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
