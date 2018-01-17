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
}
