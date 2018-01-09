//
//  RestaurantsViewController.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 07..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

class RestaurantsViewController: UITableViewController {
    @IBOutlet weak var filterBarButton: UIBarButtonItem!
    let searchController = UISearchController(searchResultsController: nil)
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var restaurants = [Restaurant?]()
    var initialRestaurants = [Restaurant?]()

    var queryTokens = Set<URLQueryToken>() {
        didSet {
            loadRestaurants(animated: true)

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

        tableView.backgroundView = activityIndicator

        loadRestaurants(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func loadRestaurants(animated: Bool = false, completionHandler: @escaping () -> Void = { }) {
        let reloadTableView = {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.separatorStyle = .singleLine
                self.tableView.reloadData()
                completionHandler()

                print("Loaded \(self.restaurants.count) restaurants")
            }
        }

        if animated {
            self.restaurants = [Restaurant?]()

            tableView.reloadData()
            tableView.separatorStyle = .none
            activityIndicator.startAnimating()
        }

        if self.queryTokens.isEmpty {
            if initialRestaurants.isEmpty {
                Restaurant.index() { restaurants in
                    self.initialRestaurants = restaurants
                    self.restaurants = self.initialRestaurants
                    reloadTableView()
                }
            } else {
                self.restaurants = self.initialRestaurants
                reloadTableView()
            }
        } else {
            self.searchController.dismiss(animated: true)
            Restaurant.index(search: Array(queryTokens)) { restaurants in
                self.restaurants = restaurants
                reloadTableView()
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
