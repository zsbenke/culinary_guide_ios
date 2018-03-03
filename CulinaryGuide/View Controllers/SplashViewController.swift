import UIKit
import SafariServices

class SplashViewController: UIViewController {
    var country = Localization.currentCountry {
        didSet {
            updateMapImageView()
        }
    }

    var partialModalDelegate = PartialModalTransitionDelegate()

    @IBOutlet weak var chooseCountryButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var mapImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.title = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        country = Localization.Country.Unknown
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        chooseCountryButton.isHidden = false
        aboutButton.isHidden = false
    }

    func updateMapImageView() {
        var mapImage: UIImage?
        switch country {
        case Localization.Country.CentralEurope:
            mapImage = #imageLiteral(resourceName: "Splash View Background Central Europe")
        case Localization.Country.Hungary:
            mapImage = #imageLiteral(resourceName: "Splash View Background Hungary")
        case Localization.Country.CzechRepublic:
            mapImage = #imageLiteral(resourceName: "Splash View Background Czech Republic")
        case Localization.Country.Slovakia:
            mapImage = #imageLiteral(resourceName: "Splash View Background Slovakia")
        case Localization.Country.Romania:
            mapImage = #imageLiteral(resourceName: "Splash View Background Romania")
        case Localization.Country.Serbia:
            mapImage = #imageLiteral(resourceName: "Splash View Background Serbia")
        case Localization.Country.Croatia:
            mapImage = #imageLiteral(resourceName: "Splash View Background Croatia")
        case Localization.Country.Slovenia:
            mapImage = #imageLiteral(resourceName: "Splash View Background Slovenia")
        default:
            mapImage = #imageLiteral(resourceName: "Splash View Background")
        }

        mapImageView.image = mapImage
    }

    func loadRestaurantsForSelectedCountry() {
        guard let presentingViewController = self.presentingViewController as? UINavigationController else { return }

        for viewController in presentingViewController.viewControllers {
            if let homeCollectionViewController = viewController as? HomeCollectionViewController {
                homeCollectionViewController.configureView()
            } else if let restaurantsViewController = viewController as? RestaurantsViewController {
                restaurantsViewController.loadAllRestaurants()
            }
        }

        dismiss(animated: true, completion: nil)
    }

    @IBAction func presentAbout(_ sender: UIButton) {
        presentAboutViewController()
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseCountry" {
            let destinationController = segue.destination
            partialModalDelegate.modalHeight = 250

            destinationController.transitioningDelegate = partialModalDelegate
            destinationController.modalPresentationStyle = .custom
        }
    }
}
