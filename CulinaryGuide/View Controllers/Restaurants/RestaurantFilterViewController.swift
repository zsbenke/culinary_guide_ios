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
            queryTokens.remove(queryToken)

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
                    switchBooleanValue(sender: control)
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

    private enum ContainingMode {
        case exclude
        case include
    }

    private func regionsSections(forCountry aCountry: Localization.Country, containment: ContainingMode) -> [Int?] {
        var sections = [Int?]()

        /*
         Filters current country from an ordered list of countries. The country order is the same as
         the region order in the RestaurantFilterViewController's storyboard. We offset sections
         manually by adding the number of preceding TableViewSections.
        */

        if Localization.currentCountry == Localization.Country.CentralEurope {
            return sections
        }

        var countries = Array(Localization.Country.cases())
        countries.remove(Localization.Country.Unknown)
        countries.remove(Localization.Country.CentralEurope)

        for (index, country) in countries.enumerated() {
            let isTheSameCountry = country == aCountry

            if containment == .include && !isTheSameCountry ||
               containment == .exclude &&  isTheSameCountry {
                continue
            }

            sections.append(index + 2)
        }

        return sections
    }

    // MARK: Storyboard actions to set queryTokens

    @IBAction func creditCardValueChanged(_ sender: UISwitch) {
        switchBooleanValue(sender: sender)
    }

    @IBAction func wifiValueChanged(_ sender: UISwitch) {
        switchBooleanValue(sender: sender)
    }

    // MARK: Manipulating queryTokens with the FilterableControls
    
    private func switchBooleanValue(sender: UISwitch!) {
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(regionsSections(forCountry: Localization.currentCountry, containment: .include))
    }
}
