//
//  RestaurantsTableViewController.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 09..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

class RestaurantsTableViewController: UITableViewController {
    var restaurants = [Restaurant?]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var restaurantsViewController: RestaurantsViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func didMove(toParentViewController parent: UIViewController?) {
        self.restaurantsViewController = parent as? RestaurantsViewController
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let restaurantsViewController = restaurantsViewController else { return }

        if segue.identifier == "showRestaurant" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let restaurant = restaurants[indexPath.row] {
                    let controller = segue.destination as! RestaurantDetailViewController
                    controller.restaurantID = restaurant.id
                    restaurantsViewController.focusSearchBarOnLoad = false
                }
            }
        } else if segue.identifier == "showFilter" {
            let controller = segue.destination.childViewControllers.first as! RestaurantFilterViewController
            controller.queryTokens = restaurantsViewController.queryTokens
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showRestaurant", sender: self)
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCellNib = UINib(nibName: "RatingWithTitleTableViewCell", bundle: nil)
        tableView.register(tableCellNib, forCellReuseIdentifier: "Cell")
        let cell: RatingWithTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RatingWithTitleTableViewCell

        if let restaurant = restaurants[indexPath.row] {
            cell.titleLabel.text = restaurant.title
            cell.detailLabel.text = restaurant.address
            if let rating = restaurant.rating {
                let ratingView = RatingView.init(rating: rating)
                cell.ratingView.addSubview(ratingView)
            }
        }

        return cell
    }
}
