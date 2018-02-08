import UIKit

class RestaurantFilterViewController: UITableViewController {
    @IBOutlet weak var openSwitch: UISwitch!
    @IBOutlet weak var creditCardSwitch: UISwitch!
    @IBOutlet weak var wifiSwitch: UISwitch!
    @IBOutlet weak var rating1FilterContainer: UIView!
    @IBOutlet weak var rating2FilterContainer: UIView!
    @IBOutlet weak var rating3FilterContainer: UIView!
    @IBOutlet weak var rating4FilterContainer: UIView!
    @IBOutlet weak var rating5FilterContainer: UIView!
    @IBOutlet weak var rating6FilterContainer: UIView!
    @IBOutlet weak var priceInformationRatingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var reserverationNeededSegmentedControl: UISegmentedControl!
    @IBOutlet weak var hasParkingSegmentedControl: UISegmentedControl!

    let generator = UINotificationFeedbackGenerator()

    let rating5FilterButton = RatingFilterButton.init(rating: RestaurantRating(points: "5"))
    let rating4FilterButton = RatingFilterButton.init(rating: RestaurantRating(points: "4"))
    let rating2FilterButton = RatingFilterButton.init(rating: RestaurantRating(points: "2"))
    let rating3FilterButton = RatingFilterButton.init(rating: RestaurantRating(points: "3"))
    let rating1FilterButton = RatingFilterButton.init(rating: RestaurantRating(points: "1"))
    let ratingPopFilterButton = RatingFilterButton.init(rating: RestaurantRating(points: "pop"))

    var filterState = RestaurantFilterState.init(queryTokens: Set<URLQueryToken>())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = UIColor.BrandColor.windowBackground

        generator.prepare()

        rating1FilterContainer.backgroundColor = .white
        rating2FilterContainer.backgroundColor = .white
        rating3FilterContainer.backgroundColor = .white
        rating4FilterContainer.backgroundColor = .white
        rating5FilterContainer.backgroundColor = .white
        rating6FilterContainer.backgroundColor = .white

        rating5FilterButton.addTarget(self, action: #selector(self.ratingValueChanged(_:)), for: .valueChanged)
        rating4FilterButton.addTarget(self, action: #selector(self.ratingValueChanged(_:)), for: .valueChanged)
        rating3FilterButton.addTarget(self, action: #selector(self.ratingValueChanged(_:)), for: .valueChanged)
        rating2FilterButton.addTarget(self, action: #selector(self.ratingValueChanged(_:)), for: .valueChanged)
        rating1FilterButton.addTarget(self, action: #selector(self.ratingValueChanged(_:)), for: .valueChanged)
        ratingPopFilterButton.addTarget(self, action: #selector(self.ratingValueChanged(_:)), for: .valueChanged)

        rating1FilterContainer.addSubview(ratingPopFilterButton)
        rating2FilterContainer.addSubview(rating1FilterButton)
        rating3FilterContainer.addSubview(rating2FilterButton)
        rating4FilterContainer.addSubview(rating3FilterButton)
        rating5FilterContainer.addSubview(rating4FilterButton)
        rating6FilterContainer.addSubview(rating5FilterButton)

        configureView()
    }

    override func viewDidLayoutSubviews() {
        rating5FilterButton.frame = CGRect(x: 0, y: 0, width: rating1FilterContainer.frame.width, height: rating1FilterContainer.frame.height)
        rating4FilterButton.frame = CGRect(x: 0, y: 0, width: rating2FilterContainer.frame.width, height: rating2FilterContainer.frame.height)
        rating3FilterButton.frame = CGRect(x: 0, y: 0, width: rating3FilterContainer.frame.width, height: rating3FilterContainer.frame.height)
        rating2FilterButton.frame = CGRect(x: 0, y: 0, width: rating4FilterContainer.frame.width, height: rating4FilterContainer.frame.height)
        rating1FilterButton.frame = CGRect(x: 0, y: 0, width: rating5FilterContainer.frame.width, height: rating5FilterContainer.frame.height)
        ratingPopFilterButton.frame = CGRect(x: 0, y: 0, width: rating6FilterContainer.frame.width, height: rating6FilterContainer.frame.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func resetFilters(_ sender: UIBarButtonItem) {
        var defaultQueryTokens = Set<URLQueryToken>()
        if let searchToken = filterState.queryTokens.searchToken() {
            defaultQueryTokens.insert(searchToken)
        }
        self.filterState = RestaurantFilterState.init(queryTokens: defaultQueryTokens)

        configureView()

        generator.notificationOccurred(.success)
    }
    
    @IBAction func filter(_ sender: UIBarButtonItem) {
        let restaurantsViewController = self.presentingViewController?.childViewControllers.filter {
            $0 is RestaurantsViewController
        }.first as! RestaurantsViewController
        
        dismiss(animated: true) {
            restaurantsViewController.queryTokens = self.filterState.queryTokens
        }
    }

    // MARK: TableView Delegate

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let regionSections = regionsSections(forCountry: Localization.currentCountry, containment: .exclude).compactMap { $0 }

        if regionSections.contains(section) {
            return nil
        }

        return super.tableView(tableView, titleForHeaderInSection: section)
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let regionSections = regionsSections(forCountry: Localization.currentCountry, containment: .exclude).compactMap { $0 }

        if regionSections.contains(section) {
            return 0.1
        }

        return super.tableView(tableView, heightForHeaderInSection: section)
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let regionSections = regionsSections(forCountry: Localization.currentCountry, containment: .exclude).compactMap { $0 }

        if regionSections.contains(section) {
            return 0.1
        }

        return super.tableView(tableView, heightForHeaderInSection: section)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let regionSections = regionsSections(forCountry: Localization.currentCountry, containment: .exclude).compactMap { $0 }

        if regionSections.contains(section) {
            return 0
        }

        return super.tableView(tableView, numberOfRowsInSection: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let regionSections = regionsSections(forCountry: Localization.currentCountry, containment: .include).compactMap { $0 }
        if regionSections.contains(indexPath.section) {
            let cell = super.tableView(tableView, cellForRowAt: indexPath)

            if let regionValue = regionValue(forCell: cell) {
                if filterState.regions.contains(regionValue) {
                    setRegionValue(filtering: true, cell: cell)
                } else {
                    setRegionValue(filtering: false, cell: cell)
                }
            }
            return cell
        }

        return super.tableView(tableView, cellForRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let regionSections = regionsSections(forCountry: Localization.currentCountry, containment: .include).compactMap { $0 }
        if regionSections.contains(indexPath.section) {
            guard let cell = tableView.cellForRow(at: indexPath) else { return }

            toggleRegionValue(cell)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: Storyboard actions to set queryTokens

    @IBAction func openValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            let currentDate = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            filterState.openAt = formatter.string(from: currentDate)
        } else {
            filterState.openAt = ""
        }
    }

    @IBAction func priceInformationRatingValueChanged(_ sender: UISegmentedControl) {
        filterState.priceInformationRating = sender.titleForSegment(at: sender.selectedSegmentIndex)
    }
    
    @IBAction func creditCardValueChanged(_ sender: UISwitch) {
        filterState.creditCard = sender.isOn
    }

    @IBAction func wifiValueChanged(_ sender: UISwitch) {
        filterState.wifi = sender.isOn
    }

    @IBAction func reservationNeededValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            filterState.reservationNeeded = true
        case 1:
            filterState.reservationNeeded = false
        default:
            filterState.reservationNeeded = nil
        }
    }

    @IBAction func hasParkingValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            filterState.hasParking = true
        case 1:
            filterState.hasParking = false
        default:
            filterState.hasParking = nil
        }
    }

    @objc func ratingValueChanged(_ sender: RatingFilterButton) {
        setRating(value: sender.rating.points, filtering: sender.isOn)
    }
}

private extension RestaurantFilterViewController {
    enum ContainingMode {
        case exclude
        case include
    }

    func configureView() {
        let configureBooleanSegmentedControls: (Bool?, UISegmentedControl) -> Void = { filterStateColumn, segmentedControl in
            if filterStateColumn != nil, let filterStateColumn = filterStateColumn {
                segmentedControl.selectedSegmentIndex = filterStateColumn ? 0 : 1
            } else {
                segmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
            }
        }

        openSwitch.setOn(!filterState.openAt.isEmpty, animated: true)
        creditCardSwitch.setOn(filterState.creditCard, animated: true)
        wifiSwitch.setOn(filterState.wifi, animated: true)

        if filterState.priceInformationRating != nil, let priceInformationRating = filterState.priceInformationRating {
            switch priceInformationRating {
            case "€":
                priceInformationRatingSegmentedControl.selectedSegmentIndex = 0
            case "€€":
                priceInformationRatingSegmentedControl.selectedSegmentIndex = 1
            case "€€€":
                priceInformationRatingSegmentedControl.selectedSegmentIndex = 2
            case "€€€€":
                priceInformationRatingSegmentedControl.selectedSegmentIndex = 3
            case "€€€€€":
                priceInformationRatingSegmentedControl.selectedSegmentIndex = 4
            default:
                priceInformationRatingSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
            }
        } else {
            priceInformationRatingSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
        }
        
        configureBooleanSegmentedControls(filterState.reservationNeeded, reserverationNeededSegmentedControl)
        configureBooleanSegmentedControls(filterState.hasParking, hasParkingSegmentedControl)

        rating5FilterButton.isOn = filterState.ratings.contains(rating5FilterButton.rating.points)
        rating4FilterButton.isOn = filterState.ratings.contains(rating4FilterButton.rating.points)
        rating3FilterButton.isOn = filterState.ratings.contains(rating3FilterButton.rating.points)
        rating2FilterButton.isOn = filterState.ratings.contains(rating2FilterButton.rating.points)
        rating1FilterButton.isOn = filterState.ratings.contains(rating1FilterButton.rating.points)
        ratingPopFilterButton.isOn = filterState.ratings.contains(ratingPopFilterButton.rating.points)

        let regionSections = IndexSet(regionsSections(forCountry: Localization.currentCountry, containment: .include).flatMap({ $0 }))
        tableView.reloadSections(regionSections, with: .none)
    }

    func regionsSections(forCountry aCountry: Localization.Country, containment: ContainingMode) -> [Int?] {
        var sections = [Int?]()
        var countries = Array(Localization.Country.cases())
        let firstRegionSectionIndex = 2
        countries.remove(Localization.Country.Unknown)
        countries.remove(Localization.Country.CentralEurope)

        /*
         Filters current country from an ordered list of countries. The country order is the same as
         the region order in the RestaurantFilterViewController's storyboard. We offset sections
         manually by adding the number of preceding TableViewSections.
         */

        if Localization.currentCountry == Localization.Country.CentralEurope {
            if containment == .include {
                for (index, _) in countries.enumerated() {
                    sections.append(index + firstRegionSectionIndex)
                }
            }

            return sections
        }

        for (index, country) in countries.enumerated() {
            let isTheSameCountry = country == aCountry

            if containment == .include && !isTheSameCountry ||
                containment == .exclude &&  isTheSameCountry {
                continue
            }

            sections.append(index + firstRegionSectionIndex)
        }

        return sections
    }

    func toggleRegionValue(_ cell: UITableViewCell) {
        guard let regionValue = regionValue(forCell: cell) else { return }

        if filterState.regions.contains(regionValue) {
            setRegionValue(filtering: false, cell: cell)
        } else {
            setRegionValue(filtering: true, cell: cell)
        }
    }

    func setRegionValue(filtering: Bool, cell: UITableViewCell) {
        guard let regionValue = regionValue(forCell: cell) else { return }

        if filtering {
            cell.accessoryType = .checkmark
            filterState.regions.insert(regionValue)
        } else {
            cell.accessoryType = .none
            filterState.regions.remove(regionValue)
        }
    }

    func regionValue(forCell cell: UITableViewCell) -> String? {
        guard let value = cell.layer.value(forKey: "tokenValue") as? String else { return nil }
        return value
    }

    func setRating(value: String, filtering: Bool) {
        if filtering {
            filterState.ratings.insert(value)
        } else {
            filterState.ratings.remove(value)
        }
    }
}
