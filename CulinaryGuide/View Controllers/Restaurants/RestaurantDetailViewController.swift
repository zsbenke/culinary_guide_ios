import UIKit

class RestaurantDetailViewController: UITableViewController {
    var restaurantID: Int? {
        didSet {
            configureView()
        }
    }
    var restaurant: Restaurant?
    var restaurantValues = [Restaurant.RestaurantValue]()
    var restaurantSections = [Restaurant.RestaurantValue.RestaurantValueSection]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never

        let tableCellNib = UINib(nibName: "DetailTitleTableViewCell", bundle: nil)
        tableView.register(tableCellNib, forCellReuseIdentifier: "Title Cell")

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
                self.restaurantValues = restaurant.toDataSource()
                self.restaurantSections = Array(Set(self.restaurantValues.map({ $0.section })))
                self.restaurantSections = self.restaurantSections.sorted(by: { (lhs, rhs) -> Bool in
                    let cases = Array(Restaurant.RestaurantValue.RestaurantValueSection.cases())

                    return cases.index(of: lhs)! < cases.index(of: rhs)!
                })
                self.tableView.reloadData()
            }
        }
    }
}

extension RestaurantDetailViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return restaurantSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = restaurantSections[section]
        return restaurantValues.filter { $0.section == section }.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = restaurantSections[indexPath.section]
        let restaurantValueInSection = restaurantValues.filter { $0.section == section }
        let restaurantValue = restaurantValueInSection[indexPath.row]

        if restaurantValue.column == .title {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Title Cell") as! DetailTitleTableViewCell
            cell.titleLabel.text = restaurant?.title
            cell.yearLabel.text = restaurant?.year

            if let rating = restaurant?.rating {
                let restaurantRating = RestaurantRating.init(points: rating)
                let ratingView = RatingView.init(rating: restaurantRating)
                cell.ratingView.addSubview(ratingView)
            }

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Value Cell")
            cell?.textLabel?.text = restaurantValue.value
            cell?.imageView?.image = restaurantValue.image
            cell?.imageView?.tintColor = UIColor.BrandColor.primary
            return cell!
        }
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let tableSectionFooterView = UIView()
        let tableViewSectionSeparator = CALayer()
        let numberOfSection = section + 1

        tableViewSectionSeparator.frame = CGRect(x: 16.0, y: 0, width: UIScreen.main.bounds.width, height: 0.5)
        tableViewSectionSeparator.backgroundColor = UIColor.BrandColor.detailSeparator.cgColor

        if numberOfSection != restaurantSections.count {
            tableSectionFooterView.layer.addSublayer(tableViewSectionSeparator)
        }

        return tableSectionFooterView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}
