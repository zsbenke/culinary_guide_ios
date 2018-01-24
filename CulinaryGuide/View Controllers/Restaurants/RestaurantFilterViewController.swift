import UIKit

class RestaurantFilterViewController: UITableViewController {
    @IBOutlet weak var openSwitch: UISwitch!
    @IBOutlet weak var creditCardSwitch: UISwitch!
    @IBOutlet weak var wifiSwitch: UISwitch!

    var filterControls = [UIView]()
    var queryTokens: Set<URLQueryToken> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filterControls.append(openSwitch)
        filterControls.append(creditCardSwitch)
        filterControls.append(wifiSwitch)

        configureViewFromQueryTokens()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func resetFilters(_ sender: UIBarButtonItem) {
        queryTokens.removeAll()

        for filterControl in filterControls {
            if let column = filterControl.tokenColumn {
                queryTokens.insert(URLQueryToken.init(column: column, value: ""))
            }
        }

        // Reset region table view sections separately
        let regionSections = IndexSet(regionsSections(forCountry: Localization.currentCountry, containment: .include).flatMap({ $0 }))
        tableView.reloadSections(regionSections, with: .none)

        configureViewFromQueryTokens()
    }
    
    @IBAction func filter(_ sender: UIBarButtonItem) {
        let restaurantsViewController = self.presentingViewController?.childViewControllers.filter {
            $0 is RestaurantsViewController
        }.first as! RestaurantsViewController
        
        dismiss(animated: true) {
            let searchQueryToken = restaurantsViewController.queryTokens.filter { $0.column == "search" }.first
            
            if let searchQueryToken = searchQueryToken { self.queryTokens.insert(searchQueryToken) }

            restaurantsViewController.queryTokens = self.queryTokens
        }
    }
    
    private func configureViewFromQueryTokens() {
        let columnsFromFilterControls = filterControls.map { $0.tokenColumn }

        queryTokens.forEach { queryToken in
            // Region query tokens configured inserted and removed in tableView(_:cellForRowAt:) method
            if queryToken.column != "region" {
                queryTokens.remove(queryToken)
            }

            let tokenHasFilterableControl = columnsFromFilterControls.contains(where: { (columnName) -> Bool in
                guard let columnName = columnName else { return false }
                return columnName == queryToken.column
            })
            
            if tokenHasFilterableControl {
                guard let filterControl = filterControls.first(where: { (control) -> Bool in
                    control.tokenColumn == queryToken.column
                }) else { return }
                guard let tokenColumn = filterControl.tokenColumn else { return }

                switch tokenColumn {
                case "wifi", "credit_card":
                    let control = filterControl as! UISwitch
                    let controlState = (queryToken.value == "true")

                    control.setOn(controlState, animated: true)
                    switchBooleanValue(control)
                case "open_at":
                    let control = filterControl as! UISwitch
                    let controlState = (queryToken.value != "")

                    control.setOn(controlState, animated: true)
                    openValueChanged(control)
                default:
                    return
                }
            }
        }
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

            if let queryToken = regionQueryToken(forCell: cell) {
                if queryTokens.contains(queryToken) {
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
        guard let tokenColum = sender.tokenColumn else { return }

        // Remove any old open_at token value
        let removeOpenFromQueryTokens: () -> Void = {
            guard let oldToken = self.queryTokens.first(where: { $0.column == tokenColum }) else { return }

            self.queryTokens.remove(oldToken)
        }

        /*
            When the switch is on, remove the old open_at token then add a new one to query tokens
            with the current date. Otherwise just remove the old open_at token.
        */
        if sender.isOn {
            let currentDate = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let queryTokenValue = formatter.string(from: currentDate)
            let queryToken = URLQueryToken.init(column: tokenColum, value: queryTokenValue)

            removeOpenFromQueryTokens()
            queryTokens.insert(queryToken)
        } else {
            removeOpenFromQueryTokens()
        }
    }


    @IBAction func creditCardValueChanged(_ sender: UISwitch) {
        switchBooleanValue(sender)
    }

    @IBAction func wifiValueChanged(_ sender: UISwitch) {
        switchBooleanValue(sender)
    }
    
    private func switchBooleanValue(_ sender: UISwitch!) {
        guard let tokenColumn = sender.tokenColumn else { return }

        let queryToken = URLQueryToken.init(column: tokenColumn, value: "\(sender.isOn)")
        let oppositeQueryToken = URLQueryToken.init(column: tokenColumn, value: "\(!sender.isOn)")

        // Clean up any query tokens either set to true or false
        queryTokens.remove(queryToken)
        queryTokens.remove(oppositeQueryToken)

        // Insert a new query token if it's set to true
        if queryToken.value == "true" {
            queryTokens.insert(queryToken)
        }
    }

    private func toggleRegionValue(_ cell: UITableViewCell) {
        guard let queryToken = regionQueryToken(forCell: cell) else { return }

        if queryTokens.contains(queryToken) {
            setRegionValue(filtering: false, cell: cell)
        } else {
            setRegionValue(filtering: true, cell: cell)
        }
    }

    private func setRegionValue(filtering: Bool, cell: UITableViewCell) {
        guard let queryToken = regionQueryToken(forCell: cell) else { return }

        if filtering {
            cell.accessoryType = .checkmark
            queryTokens.insert(queryToken)
        } else {
            cell.accessoryType = .none
            queryTokens.remove(queryToken)
        }
    }

    private func regionQueryToken(forCell cell: UITableViewCell) -> URLQueryToken? {
        guard let tokenColumn = cell.layer.value(forKey: "tokenColumn") as? String else { return nil }
        guard let tokenValue = cell.layer.value(forKey: "tokenValue") as? String else { return nil }

        let queryToken = URLQueryToken.init(column: tokenColumn, value: tokenValue)
        return queryToken
    }
}
