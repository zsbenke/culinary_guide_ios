//
//  CountriesViewController.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 11..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

class CountriesViewController: UITableViewController {
  var splashViewController: SplashViewController?
  var selectedIndexPath = IndexPath()
  var countries: [Localization.Country] {
    return Array(Localization.Country.cases()).filter { $0 != Localization.Country.Unknown }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

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
    animateMapView(upward: false)
    dismiss(animated: true) {
      guard let splashViewController = self.splashViewController else { return }
      splashViewController.loadRestaurantsForSelectedCountry()
    }
  }

  private func animateMapView(upward: Bool, delay: TimeInterval = 0.0, completion: (() -> Void)? = nil) {
    guard let splashViewController = self.splashViewController else { return }

    if upward {
      UIView.animate(withDuration: 0.3, delay: delay, options: .curveEaseOut, animations: {
        splashViewController.mapImageView.transform = CGAffineTransform.init(translationX: 0, y: -90)
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
