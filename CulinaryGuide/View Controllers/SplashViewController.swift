import UIKit

class SplashViewController: UIViewController {
    var country = Localization.currentCountry {
        didSet {
            updateMapImageView()
        }
    }
    @IBOutlet weak var chooseCountryButton: UIButton!
    @IBOutlet weak var mapImageView: UIImageView!
    var partialModalDelegate = PartialModalTransitionDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.tintColor = UIColor.BrandColor.primarySplashScreen
        view.backgroundColor = UIColor.BrandColor.secondary
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.country = Localization.Country.Unknown
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
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
        performSegue(withIdentifier: "loadRestaurantsForCountry", sender: self)
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
