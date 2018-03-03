import UIKit

class RestaurantsTableViewController: UITableViewController {
    var restaurants = [Restaurant?]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
                self.tableView.reloadData()
            }
        }
    }
    var restaurantsViewController: RestaurantsViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        let tableCellNib = UINib(nibName: "IconTableViewCell", bundle: nil)
        tableView.register(tableCellNib, forCellReuseIdentifier: "Cell")


        registerForPreviewing(with: self, sourceView: view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        if let indexPath = tableView.indexPathForRow(at: location), let cell = tableView.cellForRow(at: indexPath) {
            if let restaurant = restaurants[indexPath.row] {
                previewingContext.sourceRect = cell.frame
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let restaurantDetailViewController = storyboard.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
                restaurantDetailViewController.restaurantID = restaurant.id

                return restaurantDetailViewController
            }
        }

        return nil
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}
