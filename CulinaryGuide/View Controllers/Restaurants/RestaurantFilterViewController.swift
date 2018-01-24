import UIKit

class RestaurantFilterViewController: UITableViewController {
    @IBOutlet weak var openSwitch: UISwitch!
    @IBOutlet weak var creditCardSwitch: UISwitch!
    @IBOutlet weak var wifiSwitch: UISwitch!

    var filterState = RestaurantFilterState.init(queryTokens: Set<URLQueryToken>())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func resetFilters(_ sender: UIBarButtonItem) {
        self.filterState = RestaurantFilterState.init(queryTokens: Set<URLQueryToken>())
        configureView()
    }
    
    @IBAction func filter(_ sender: UIBarButtonItem) {
        let restaurantsViewController = self.presentingViewController?.childViewControllers.filter {
            $0 is RestaurantsViewController
        }.first as! RestaurantsViewController
        
        dismiss(animated: true) {
            restaurantsViewController.queryTokens = self.filterState.queryTokens
        }
    }
    
    private func configureView() {
        openSwitch.setOn(!filterState.openAt.isEmpty, animated: true)
        creditCardSwitch.setOn(filterState.creditCard, animated: true)
        wifiSwitch.setOn(filterState.wifi, animated: true)

        let regionSections = IndexSet(regionsSections(forCountry: Localization.currentCountry, containment: .include).flatMap({ $0 }))
        tableView.reloadSections(regionSections, with: .none)
    }

    // MARK: TableView Delegate

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let regionSections = regionsSections(forCountry: Localization.currentCountry, containment: .exclude).flatMap { $0 }

        if regionSections.contains(section) {
            return nil
        }

        return super.tableView(tableView, titleForHeaderInSection: section)
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let regionSections = regionsSections(forCountry: Localization.currentCountry, containment: .exclude).flatMap { $0 }

        if regionSections.contains(section) {
            return 0.1
        }

        return super.tableView(tableView, heightForHeaderInSection: section)
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let regionSections = regionsSections(forCountry: Localization.currentCountry, containment: .exclude).flatMap { $0 }

        if regionSections.contains(section) {
            return 0.1
        }

        return super.tableView(tableView, heightForHeaderInSection: section)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let regionSections = regionsSections(forCountry: Localization.currentCountry, containment: .exclude).flatMap { $0 }

        if regionSections.contains(section) {
            return 0
        }

        return super.tableView(tableView, numberOfRowsInSection: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let regionSections = regionsSections(forCountry: Localization.currentCountry, containment: .include).flatMap { $0 }
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
        let regionSections = regionsSections(forCountry: Localization.currentCountry, containment: .include).flatMap { $0 }
        if regionSections.contains(indexPath.section) {
            guard let cell = tableView.cellForRow(at: indexPath) else { return }

            toggleRegionValue(cell)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    private enum ContainingMode {
        case exclude
        case include
    }

    private func regionsSections(forCountry aCountry: Localization.Country, containment: ContainingMode) -> [Int?] {
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

    @IBAction func creditCardValueChanged(_ sender: UISwitch) {
        filterState.creditCard = sender.isOn
    }

    @IBAction func wifiValueChanged(_ sender: UISwitch) {
        filterState.wifi = sender.isOn
    }

    private func toggleRegionValue(_ cell: UITableViewCell) {
        guard let regionValue = regionValue(forCell: cell) else { return }

        if filterState.regions.contains(regionValue) {
            setRegionValue(filtering: false, cell: cell)
        } else {
            setRegionValue(filtering: true, cell: cell)
        }
    }

    private func setRegionValue(filtering: Bool, cell: UITableViewCell) {
        guard let regionValue = regionValue(forCell: cell) else { return }

        if filtering {
            cell.accessoryType = .checkmark
            filterState.regions.insert(regionValue)
        } else {
            cell.accessoryType = .none
            filterState.regions.remove(regionValue)
        }
    }

    private func regionValue(forCell cell: UITableViewCell) -> String? {
        guard let value = cell.layer.value(forKey: "tokenValue") as? String else { return nil }
        return value
    }
}
