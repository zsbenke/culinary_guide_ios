//
//  SplashViewController.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 12..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
  var country = Localization.currentCountry {
    didSet {
      updateMapImageView()
    }
  }
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
    self.country = Localization.Country.Unknown
  }

  override func viewWillDisappear(_ animated: Bool) {
    self.navigationController?.isNavigationBarHidden = false
  }

  func updateMapImageView() {
    var mapImage: UIImage?
    switch country {
    case Localization.Country.CentralEurope:
      mapImage = #imageLiteral(resourceName: "Splash View Background Central Europe")
    case Localization.Country.Hungary:
      mapImage = #imageLiteral(resourceName: "Splash View Background Hungary")
    case Localization.Country.CzechRepublic:
      mapImage = #imageLiteral(resourceName: "Splash View Background Czech Republic")
    case Localization.Country.Slovakia:
      mapImage = #imageLiteral(resourceName: "Splash View Background Slovakia")
    case Localization.Country.Romania:
      mapImage = #imageLiteral(resourceName: "Splash View Background Romania")
    case Localization.Country.Serbia:
      mapImage = #imageLiteral(resourceName: "Splash View Background Serbia")
    case Localization.Country.Croatia:
      mapImage = #imageLiteral(resourceName: "Splash View Background Croatia")
    case Localization.Country.Slovenia:
      mapImage = #imageLiteral(resourceName: "Splash View Background Slovenia")
    default:
      mapImage = #imageLiteral(resourceName: "Splash View Background")
    }

    mapImageView.image = mapImage
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