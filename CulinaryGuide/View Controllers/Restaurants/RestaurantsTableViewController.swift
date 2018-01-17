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
        let cell: IconTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! IconTableViewCell

        if let restaurant = restaurants[indexPath.row] {
            cell.titleLabel.text = restaurant.title
            cell.detailLabel.text = restaurant.address
            if let rating = restaurant.rating {
                let restaurantRating = RestaurantRating.init(points: rating)
                let ratingView = RatingView.init(rating: restaurantRating)
                if cell.iconView.subviews.count == 0 {
                    cell.iconView.addSubview(ratingView)
                }
            }
        }

        return cell
    }
}
