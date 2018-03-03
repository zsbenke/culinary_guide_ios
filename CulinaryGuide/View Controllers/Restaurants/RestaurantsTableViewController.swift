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

        let tableCellNib = UINib(nibName: "IconTableViewCell", bundle: nil)
        tableView.register(tableCellNib, forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func didMove(toParentViewController parent: UIViewController?) {
        self.restaurantsViewController = parent as? RestaurantsViewController
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.registerForPreviewing(with: self, sourceView: tableView)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let restaurantsViewController = restaurantsViewController else { return }

        if segue.identifier == "showRestaurant" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let restaurant = restaurants[indexPath.row] {
                    let controller = segue.destination as! RestaurantDetailViewController
                    controller.restaurantID = restaurant.id
                    restaurantsViewController.presentSearchController = false
                }
            }
        } else if segue.identifier == "showFilter" {
            let controller = segue.destination.childViewControllers.first as! RestaurantFilterViewController
            controller.filterState = RestaurantFilterState.init(queryTokens: restaurantsViewController.queryTokens)
        }
    }
}

// MARK: - Table View

extension RestaurantsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showRestaurant", sender: self)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: IconTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! IconTableViewCell

        if let restaurant = restaurants[indexPath.row] {
            cell.titleLabel.text = restaurant.title
            cell.detailLabel.text = restaurant.address
            if let rating = restaurant.rating {
                let restaurantRating = RestaurantRating.init(points: rating)
                let ratingView = RatingView.init(rating: restaurantRating)

                for view in cell.iconView.subviews {
                    view.removeFromSuperview()
                }
                cell.iconView.addSubview(ratingView)
            }
        }

        return cell
    }
}

extension RestaurantsTableViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if ((self.presentedViewController?.isKind(of: RestaurantDetailViewController.self)) != nil) {
            return nil
        }

        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let restaurantDetailViewController = storyboard.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
        let cellPosition = tableView.convert(location, from: tableView)
        if let indexPath = tableView.indexPathForRow(at: cellPosition) {
            print(indexPath.row)
            if let restaurant = restaurants[indexPath.row] {
                restaurantDetailViewController.restaurantID = restaurant.id
            }
        }

        return restaurantDetailViewController
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.show(viewControllerToCommit, sender: self)
    }
}
