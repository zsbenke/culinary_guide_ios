//
//  MasterViewController.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 07..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import Foundation
import UIKit

class RestaurantsViewController: UITableViewController {
    let searchController = UISearchController(searchResultsController: nil)
    var restaurants = [Restaurant?]() {
        didSet {
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
    }
    var cachedRestaurants = [Restaurant?]()

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

    func loadRestaurants(query: String = "") {
        if query.isEmpty {
            Restaurant.index { restaurants in
                self.restaurants = restaurants

                if self.cachedRestaurants.isEmpty {
                    self.cachedRestaurants = restaurants
                }
            }
        } else {
            let searchToken = URLQueryToken.init(column: "search", value: query)
            Restaurant.index(search: [searchToken]) { restaurants in
                self.restaurants = restaurants
                self.searchController.dismiss(animated: true)

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
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
        self.restaurants = cachedRestaurants
    }
}

extension RestaurantsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.restaurants = cachedRestaurants
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        loadRestaurants(query: searchText)
    }
}

