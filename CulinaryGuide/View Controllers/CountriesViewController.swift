//
//  CountriesViewController.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 11..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

class CountriesViewController: UITableViewController {
  let defaults = UserDefaults.standard
  var selectedIndexPath = IndexPath()
  var selectedCountry = Localization.Country.Unknown
  var countries: [Localization.Country] {
    return Array(Localization.Country.cases()).filter { $0 != Localization.Country.Unknown }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  @IBAction func cancel(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }

  @IBAction func setCountry(_ sender: Any) {
    dismiss(animated: true) {
      self.defaults.set("\(self.selectedCountry)", forKey: "Country")
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
    cell.textLabel!.text = "\(country)"

    if indexPath == selectedIndexPath {
      cell.accessoryType = .checkmark
    } else {
      cell.accessoryType = .none
    }

    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.accessoryType = .checkmark
    self.selectedIndexPath = indexPath
    self.selectedCountry = countries[indexPath.row]

    tableView.deselectRow(at: indexPath, animated: true)
    tableView.reloadData()
  }

  override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    tableView.cellForRow(at: indexPath)?.accessoryType = .none
  }
}
