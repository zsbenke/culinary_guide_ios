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
    var restaurants = [Restaurant?]()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.delegate = self
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController

        Restaurant.index { (loadedRestaurants) in
            self.restaurants = loadedRestaurants
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

        let restaurant = restaurants[indexPath.row] as! Restaurant
        cell.textLabel!.text = restaurant.title
        return cell
    }
}

extension RestaurantsViewController: UISearchControllerDelegate {

}

extension RestaurantsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchToken = URLQueryToken.init(column: "search", value: searchBar.text!)
        Restaurant.index(search: [searchToken]) { restaurants in
            self.restaurants = restaurants
            self.searchController.dismiss(animated: true)

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

