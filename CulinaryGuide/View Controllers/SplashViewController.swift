//
//  SplashViewController.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 12..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
  @IBOutlet weak var mapImageView: UIImageView!
  var partialModalDelegate = PartialModalTransitionDelegate()

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.isNavigationBarHidden = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    self.navigationController?.isNavigationBarHidden = false
  }

  func updateMapImageView() {
    print("updated map image view")
  }

  func loadRestaurantsForSelectedCountry() {
    performSegue(withIdentifier: "loadRestaurantsForCountry", sender: self)
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
