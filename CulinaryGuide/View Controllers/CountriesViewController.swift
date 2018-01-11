//
//  CountriesViewController.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 11..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

class CountriesViewController: UITableViewController {
  var countries: [Localization.Country] {
    return Array(Localization.Country.cases())
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  // MARK: - Segues

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "chooseCountry" {
      if let indexPath = tableView.indexPathForSelectedRow {
        let country = countries[indexPath.row]
        let defaults = UserDefaults.standard
        defaults.set("\(country)", forKey: "Country")
      }
    }
  }

  // MARK: - Table View

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print(countries)
    return countries.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
    let country = countries[indexPath.row]
    cell.textLabel!.text = "\(country)"

    return cell
  }
}
