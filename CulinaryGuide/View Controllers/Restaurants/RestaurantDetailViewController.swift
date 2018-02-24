import UIKit

class RestaurantDetailViewController: UITableViewController {
    var restaurantID: Int? {
        didSet {
            configureView()
        }
    }

    private var restaurant: Restaurant?
    private var restaurantValues = [Restaurant.RestaurantValue]()
    private var restaurantSections = [Restaurant.RestaurantValue.RestaurantValueSection]()
    private var headerView: DetailTitleView!
    private var headerViewHeight: CGFloat = 320.0
    private let emptyImage = UIImage()
    private let navigationBarAnimation = CATransition()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        tableView.contentInsetAdjustmentBehavior = .never

        navigationBarAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        navigationBarAnimation.type = kCATransitionFade
        navigationBarAnimation.duration = 0.5


        if restaurant != nil {
            configureView()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        switchNavigationBarAppearance(to: .transparent)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        switchNavigationBarAppearance(to: .default)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

        let cell = tableView.dequeueReusableCell(withIdentifier: "Value Cell")
        cell?.textLabel?.text = restaurantValue.value
        cell?.imageView?.image = restaurantValue.image
        return cell!
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let tableSectionFooterView = UIView()
        let tableViewSectionSeparator = CALayer()
        let numberOfSection = section + 1

        tableViewSectionSeparator.frame = CGRect(x: 16.0, y: 0, width: UIScreen.main.bounds.width, height: (1.0 / UIScreen.main.scale))
        tableViewSectionSeparator.backgroundColor = UIColor.BrandColor.separator.cgColor

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

extension RestaurantDetailViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
}

private extension RestaurantDetailViewController {
    enum NavigationBarAppearance {
        case `default`
        case transparent
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

                let headerViewFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: self.headerViewHeight)
                self.headerView = DetailTitleView.init(frame: headerViewFrame)
                self.headerView.titleLabel.text = restaurant.title
                self.headerView.yearLabel.text = restaurant.year

                if let rating = restaurant.rating {
                    let restaurantRating = RestaurantRating.init(points: rating)
                    let ratingView = RatingView.init(rating: restaurantRating)
                    self.headerView.ratingView.addSubview(ratingView)
                }

                self.tableView.tableHeaderView = nil
                self.tableView.addSubview(self.headerView)

                self.tableView.contentInset = UIEdgeInsets(top: self.headerViewHeight, left: 0, bottom: 0, right: 0)
                self.tableView.contentOffset = CGPoint(x: 0, y: -self.headerViewHeight)

                self.updateHeaderView()

                self.tableView.reloadData()
            }
        }
    }

    func updateHeaderView() {
        var headerViewFrame = CGRect(x: 0, y: -headerViewHeight, width: tableView.bounds.width, height: headerViewHeight)

        if tableView.contentOffset.y <  -headerViewHeight {
            headerViewFrame.origin.y = tableView.contentOffset.y
            headerViewFrame.size.height = -tableView.contentOffset.y

            let heroGradientAlpha = (420 + tableView.contentOffset.y) / 100

            if heroGradientAlpha >= 0 {
                headerView.heroImageGradient.alpha = heroGradientAlpha
                self.navigationController?.navigationBar.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: heroGradientAlpha)
            }
        } else if tableView.contentOffset.y < -70 {
            switchNavigationBarAppearance(to: .transparent)
        } else {
            switchNavigationBarAppearance(to: .default)
        }



        headerView.frame = headerViewFrame
    }

    func switchNavigationBarAppearance(to appearance: NavigationBarAppearance) {
        switch appearance {
        case .default:
            navigationController?.navigationBar.layer.add(navigationBarAnimation, forKey: nil)
            UIView.animate(withDuration: 0.4, animations: {
                UIApplication.shared.statusBarStyle = .default
                self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
                self.navigationController?.navigationBar.shadowImage = nil
                self.navigationController?.navigationBar.tintColor = UIColor.BrandColor.primary
                self.navigationController?.navigationBar.topItem?.title = self.restaurant?.title
            }, completion: nil)
        case .transparent:
            navigationController?.navigationBar.layer.add(navigationBarAnimation, forKey: nil)
            UIView.animate(withDuration: 0.4, animations: {
                UIApplication.shared.statusBarStyle = .lightContent
                self.navigationController?.navigationBar.setBackgroundImage(self.emptyImage, for: .default)
                self.navigationController?.navigationBar.shadowImage = self.emptyImage
                self.navigationController?.navigationBar.tintColor = .white
                self.navigationController?.navigationBar.topItem?.title = ""
            }, completion: nil)
        }
    }
}
