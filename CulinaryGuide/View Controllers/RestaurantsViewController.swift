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
            let restaurantsTableViewController = self.childViewControllers.first as! RestaurantsTableViewController

            restaurantsTableViewController.loadRestaurants(animated: true)

            var filterTokens = queryTokens
            filterTokens.renameSearchTokens()

            if filterTokens.isEmpty {
                filterBarButton.image = #imageLiteral(resourceName: "Toolbar Filter Icon")
            } else {
                filterBarButton.image = #imageLiteral(resourceName: "Toolbar Filter Icon Filled")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.delegate = self
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController

        navigationItem.hidesSearchBarWhenScrolling = false
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
