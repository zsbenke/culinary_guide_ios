//
//  RestaurantsViewController.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 07..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

class RestaurantsViewController: UIViewController {
  @IBOutlet weak var filterBarButton: UIBarButtonItem!
  @IBOutlet weak var listContainerView: UIView!
  @IBOutlet weak var mapContainerView: UIView!

  let searchController = UISearchController(searchResultsController: nil)
  var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
  var restaurants = [Restaurant?]()
  var initialRestaurants = [Restaurant?]()

  var queryTokens = Set<URLQueryToken>() {
    didSet {
      var filterTokens = queryTokens
      filterTokens.renameSearchTokens()

      if filterTokens.isEmpty {
        filterBarButton.image = #imageLiteral(resourceName: "Toolbar Filter Icon")
      } else {
        filterBarButton.image = #imageLiteral(resourceName: "Toolbar Filter Icon Filled")
      }

      loadRestaurants()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    searchController.delegate = self
    searchController.searchBar.delegate = self
    self.navigationItem.searchController = searchController

    navigationItem.hidesSearchBarWhenScrolling = false

    loadRestaurants {
      print("Loaded \(self.restaurants.count) restaurants")
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func switchContainerViews(_ sender: UISegmentedControl) {
    if sender.selectedSegmentIndex == 0 {
      listContainerView.alpha = 1
      mapContainerView.alpha = 0
    } else {
      listContainerView.alpha = 0
      mapContainerView.alpha = 1
    }
  }

  func loadRestaurants(completionHandler: @escaping () -> Void = { }) {
    let restaurantsTableViewController = self.childViewControllers[0] as! RestaurantsTableViewController
    let restaurantsMapViewController = self.childViewControllers[1] as! RestaurantsMapViewController

    if queryTokens.isEmpty {
      if initialRestaurants.isEmpty {
        Restaurant.index() { restaurants in
          self.initialRestaurants = restaurants
          self.restaurants = self.initialRestaurants
          restaurantsTableViewController.restaurants = self.restaurants
          restaurantsMapViewController.restaurants = self.restaurants
          completionHandler()
        }
      } else {
        self.restaurants = self.initialRestaurants
        restaurantsTableViewController.restaurants = self.restaurants
        restaurantsMapViewController.restaurants = self.restaurants
        completionHandler()
      }
    } else {
      searchController.dismiss(animated: true)
      Restaurant.index(search: Array(queryTokens)) { restaurants in
        self.restaurants = restaurants
        restaurantsTableViewController.restaurants = self.restaurants
        restaurantsMapViewController.restaurants = self.restaurants
        completionHandler()
      }
    }
  }

  // MARK: - Segues

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showFilter" {
      let controller = segue.destination.childViewControllers.first as! RestaurantFilterViewController
      controller.queryTokens = queryTokens
    }
  }
}

// MARK: - Searching

extension RestaurantsViewController: UISearchControllerDelegate {
  func didDismissSearchController(_ searchController: UISearchController) {
    self.queryTokens.renameSearchTokens()
  }
}

extension RestaurantsViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let searchText = searchBar.text else { return }
    var newTokens = queryTokens
    newTokens.renameSearchTokens()
    newTokens.insert(URLQueryToken.init(column: "search", value: searchText))
    self.queryTokens = newTokens
  }
}
