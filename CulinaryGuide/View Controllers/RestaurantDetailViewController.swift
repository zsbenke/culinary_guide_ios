//
//  RestaurantDetailsViewController.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 07..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UITableViewController {
    var restaurantID: Int? {
        didSet {
            configureView()
        }
    }
    var restaurant: Restaurant?

    @IBOutlet weak var addressCell: UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.largeTitleDisplayMode = .never

        if restaurant != nil {
            configureView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureView() {
        guard let restaurantID = restaurantID else { return }
        Restaurant.show(restaurantID) { restaurant in
            self.restaurant = restaurant

            DispatchQueue.main.async {
                guard let restaurant = self.restaurant else { return }
                self.navigationItem.title = restaurant.title

                guard let cell = self.addressCell else { return }
                cell.detailTextLabel?.text = restaurant.address
            }
        }
    }
}
