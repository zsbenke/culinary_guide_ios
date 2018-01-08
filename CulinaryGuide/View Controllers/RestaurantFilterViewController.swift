//
//  RestaurantFilterViewController.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 08..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

class RestaurantFilterViewController: UITableViewController {
    var queryTokens = Set<URLQueryToken>()

    @IBOutlet weak var openSwitch: UISwitch!
    @IBOutlet weak var creditCardSwitch: UISwitch!
    @IBOutlet weak var wifiSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        let uiSwitches: [UISwitch] = [openSwitch, creditCardSwitch, wifiSwitch]
        for uiSwitch in uiSwitches {
            uiSwitch.addTarget(self, action: #selector(self.switchDidChangeValue), for: .valueChanged)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    @IBAction func filter(_ sender: UIBarButtonItem) {
        let restaurantsViewController = self.presentingViewController?.childViewControllers.first as! RestaurantsViewController

        dismiss(animated: true) {
            let searchQueryToken = restaurantsViewController.queryTokens.filter { $0.column == "search" }.first

            if let searchQueryToken = searchQueryToken {
                self.queryTokens.insert(searchQueryToken)
            }

            restaurantsViewController.queryTokens = self.queryTokens
        }
    }

    @objc private func switchDidChangeValue(sender: UISwitch!) {
        guard let tokenColumn = tokenColumn(uiSwitch: sender) else { return }

        let queryToken = URLQueryToken.init(column: tokenColumn, value: "\(sender.isOn)")

        self.queryTokens.remove(queryToken)

        if queryToken.value == "true" {
            self.queryTokens.insert(queryToken)
        }
        print(queryTokens)
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
