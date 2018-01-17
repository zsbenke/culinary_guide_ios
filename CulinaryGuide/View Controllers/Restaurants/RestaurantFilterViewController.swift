import UIKit

class RestaurantFilterViewController: UITableViewController {
    @IBOutlet weak var openSwitch: UISwitch!
    @IBOutlet weak var creditCardSwitch: UISwitch!
    @IBOutlet weak var wifiSwitch: UISwitch!
    
    var queryTokens: Set<URLQueryToken> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uiSwitches: [UISwitch] = [openSwitch, creditCardSwitch, wifiSwitch]
        for uiSwitch in uiSwitches {
            uiSwitch.addTarget(self, action: #selector(self.switchDidChangeValue), for: .valueChanged)
        }

        configureViewFromQueryTokens()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func resetFilters(_ sender: UIBarButtonItem) {
        self.queryTokens = [
            URLQueryToken.init(column: "open", value: ""),
            URLQueryToken.init(column: "credit_card", value: ""),
            URLQueryToken.init(column: "wifi", value: "")
        ]
        configureViewFromQueryTokens()
    }
    
    @IBAction func filter(_ sender: UIBarButtonItem) {
        let restaurantsViewController = self.presentingViewController?.childViewControllers.filter {
            $0 is RestaurantsViewController
            }.first as! RestaurantsViewController
        
        dismiss(animated: true) {
            let searchQueryToken = restaurantsViewController.queryTokens.filter { $0.column == "search" }.first
            
            if let searchQueryToken = searchQueryToken {
                self.queryTokens.insert(searchQueryToken)
            }

            restaurantsViewController.queryTokens = self.queryTokens
        }
    }
    
    private func configureViewFromQueryTokens() {
        let uiSwitchDictionary = [
            "open": openSwitch,
            "credit_card": creditCardSwitch,
            "wifi": wifiSwitch
        ]
        
        queryTokens.forEach { queryToken in
            queryTokens.remove(queryToken)
            
            if uiSwitchDictionary.keys.contains(queryToken.column) {
                if let uiSwitch = uiSwitchDictionary[queryToken.column] {
                    let uiSwitchState = (queryToken.value == "true")
                    if let uiSwitch = uiSwitch {
                        uiSwitch.setOn(uiSwitchState, animated: true)
                        switchDidChangeValue(sender: uiSwitch)
                    }
                }
            }
        }
    }
    
    @objc private func switchDidChangeValue(sender: UISwitch!) {
        guard let tokenColumn = tokenColumn(uiSwitch: sender) else { return }
        
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
    
    private func tokenColumn(uiSwitch: UISwitch) -> String? {
        switch uiSwitch {
        case openSwitch:
            return "open"
        case creditCardSwitch:
            return "credit_card"
        case wifiSwitch:
            return "wifi"
        default:
            return nil
        }
    }
}
