import UIKit

class CountriesViewController: UITableViewController {
    var splashViewController: SplashViewController?
    var selectedIndexPath = IndexPath()
    var countries: [Localization.Country] {
        return Array(Localization.Country.cases()).filter { $0 != Localization.Country.Unknown }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.layer.addBorder(edge: .top, color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.2), thickness: 0.5)

        self.splashViewController = presentingViewController?.childViewControllers.filter {
            $0 is SplashViewController
            }.first as? SplashViewController
        UserDefaults.standard.set("\(Localization.Country.Unknown)", forKey: "\(UserDefaultKey.country)")
    }

    override func viewWillAppear(_ animated: Bool) {
        animateMapView(upward: true, delay: 0.05)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        guard let splashViewController = self.splashViewController else { return }
        splashViewController.country = Localization.Country.Unknown
        UserDefaults.standard.set("\(Localization.Country.Unknown)", forKey: "\(UserDefaultKey.country)")
        animateMapView(upward: false)
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func setCountry(_ sender: Any) {
        animateMapView(upward: false, hideCountryChooserButton: true)
        dismiss(animated: true) {
            guard let splashViewController = self.splashViewController else { return }
            splashViewController.loadRestaurantsForSelectedCountry()
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        let country = countries[indexPath.row]
        cell.textLabel!.text = country.name

        if indexPath == selectedIndexPath {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let splashViewController = self.splashViewController else { return }
        self.selectedIndexPath = indexPath

        let country = countries[indexPath.row]
        UserDefaults.standard.set("\(country)", forKey: "\(UserDefaultKey.country)")
        splashViewController.country = country

        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()

        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}

private extension CountriesViewController {
    func animateMapView(upward: Bool, hideCountryChooserButton: Bool = false, delay: TimeInterval = 0.0, completion: (() -> Void)? = nil) {
        guard let splashViewController = self.splashViewController else { return }

        if hideCountryChooserButton {
            splashViewController.chooseCountryButton.isHidden = true
            splashViewController.aboutButton.isHidden = true
        }

        let yTranslation = UIScreen.main.bounds.height / 9

        if upward {
            UIView.animate(withDuration: 0.3, delay: delay, options: .curveEaseOut, animations: {
                splashViewController.mapImageView.transform = CGAffineTransform.init(translationX: 0, y: -yTranslation)
            }, completion: { finished in
                guard let completion = completion else { return }
                completion()
            })
        } else {
            UIView.animate(withDuration: 0.3, delay: delay, options: .curveEaseOut, animations: {
                splashViewController.mapImageView.transform = CGAffineTransform.identity
            }, completion: { finished in
                guard let completion = completion else { return }
                completion()
            })
        }
    }
}
