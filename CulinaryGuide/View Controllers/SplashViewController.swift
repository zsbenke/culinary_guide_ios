//
//  SplashViewController.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 12..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
  var loadRestaurantsForCountrySeguePerformed: Bool?
  var partialModalDelegate = PartialModalTransitionDelegate()

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    print("\(#function)")
    self.navigationController?.isNavigationBarHidden = true
    self.loadRestaurantsForCountrySeguePerformed = false
    UserDefaults.standard.addObserver(self, forKeyPath: "Country", options: .new, context: nil)
  }

  override func viewWillDisappear(_ animated: Bool) {
    print("\(#function)")
    self.navigationController?.isNavigationBarHidden = false
    self.loadRestaurantsForCountrySeguePerformed = false
    UserDefaults.standard.removeObserver(self, forKeyPath: "Country")
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  // MARK: - Country settings change observer

  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "Country" {
      print("changed country")
      guard let loadRestaurantsForCountrySeguePerformed = loadRestaurantsForCountrySeguePerformed else { return }
      if !loadRestaurantsForCountrySeguePerformed {
        performSegue(withIdentifier: "loadRestaurantsForCountry", sender: self)
        self.loadRestaurantsForCountrySeguePerformed = true
      }
    }
  }

  deinit {
    UserDefaults.standard.removeObserver(self, forKeyPath: "Country")
  }

  // MARK: - Segues

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "chooseCountry" {
      let destinationController = segue.destination
      partialModalDelegate.modalHeight = 250
      destinationController.transitioningDelegate = partialModalDelegate
      destinationController.modalPresentationStyle = .custom
    }
  }
}
