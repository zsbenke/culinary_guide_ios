//
//  MasterViewController.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 07..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

class RestaurantsViewController: UITableViewController {
    let searchController = UISearchController(searchResultsController: nil)
    var restaurants = [Restaurant?]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    var queryTokens = Set<URLQueryToken>() {
        didSet {
            loadRestaurants()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.delegate = self
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController

        loadRestaurants()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func loadRestaurants() {
        if self.queryTokens.isEmpty {
            Restaurant.index() { restaurants in
                self.restaurants = restaurants
            }
        } else {
            Restaurant.index(search: Array(queryTokens)) { restaurants in
                self.restaurants = restaurants

                self.searchController.dismiss(animated: true)
            }
        }

    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurant" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let restaurant = restaurants[indexPath.row] {
                    let controller = segue.destination as! RestaurantDetailViewController
                    controller.restaurantID = restaurant.id
                }
            }
        } else if segue.identifier == "showFilter" {
            let controller = segue.destination.childViewControllers.first as! RestaurantFilterViewController
            controller.queryTokens = queryTokens
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(restaurants.count)
        return restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        if let restaurant = restaurants[indexPath.row] {
            cell.textLabel!.text = restaurant.title
        }
        return cell
    }
}

// MARK: - Searching

extension RestaurantsViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        self.queryTokens.clearSearchTokens()
    }
}

extension RestaurantsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.queryTokens.clearSearchTokens()
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        var newTokens = queryTokens
        newTokens.clearSearchTokens()
        newTokens.insert(URLQueryToken.init(column: "search", value: searchText))
        self.queryTokens = newTokens
    }
}
