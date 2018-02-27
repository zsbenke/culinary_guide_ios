import UIKit
import CoreSpotlight
import MobileCoreServices
import MapKit

class RestaurantDetailViewController: UITableViewController {
    var restaurantID: Int? {
        didSet {
            configureView()
        }
    }

    private var restaurant: Restaurant?
    private var restaurantValues = [Restaurant.RestaurantValue]()
    private var restaurantSections = [Restaurant.RestaurantValue.RestaurantValueSection]()
    private var headerImage: UIImage?
    private var headerView: DetailTitleView!
    private var headerViewHeight: CGFloat {
        guard headerImage != nil else { return 220.0 }
        return 320.0
    }
    private let navigationBarAnimation = CATransition()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        tableView.contentInsetAdjustmentBehavior = .never

        navigationBarAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        navigationBarAnimation.type = kCATransitionFade
        navigationBarAnimation.duration = 0.5
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

        let cell = dequeueResuableCell(for: restaurantValue)
        cell?.textLabel?.text = restaurantValue.value
        cell?.imageView?.image = restaurantValue.image

        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = restaurantSections[indexPath.section]
        let restaurantValueInSection = restaurantValues.filter { $0.section == section }
        let restaurantValue = restaurantValueInSection[indexPath.row]

        defer {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.setSelected(false, animated: true)
        }

        if restaurantValue.column == .address {
            guard let address = restaurant?.address?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            guard let mapsURL = URL(string: "http://maps.apple.com/?address=\(address)") else { return }
            UIApplication.shared.open(mapsURL, options: [:], completionHandler: nil)
        }

        if restaurantValue.column == .phone {
            guard let phone = restaurant?.phone?.filter({ "0123456789".contains($0) }) else { return }
            guard let phoneURL = URL(string: "tel:\(phone)") else { return }
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        }

        if restaurantValue.column == .website {
            guard let website = restaurant?.website else { return }
            UIApplication.shared.open(website, options: [:], completionHandler: nil)
        }

        if restaurantValue.column == .facebookPage {
            guard let facebookPage = restaurant?.facebookPage else { return }
            UIApplication.shared.open(facebookPage, options: [:], completionHandler: nil)
        }

        if restaurantValue.column == .email {
            guard let email = restaurant?.email else { return }
            guard let mailtoURL = URL(string: "mailto:\(email)") else { return }
            UIApplication.shared.open(mailtoURL, options: [:], completionHandler: nil)
        }
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

extension RestaurantDetailViewController: NSUserActivityDelegate {
    override func updateUserActivityState(_ activity: NSUserActivity) {
        var userInfo = [String: AnyObject]()
        userInfo["placemark"] = NSKeyedArchiver.archivedData(withRootObject: (activity.mapItem.placemark)) as AnyObject?

        if let url = activity.mapItem.url {
            userInfo["url"] = url as AnyObject?
        }

        if let phoneNumber = activity.mapItem.phoneNumber {
            userInfo["phoneNumber"] = phoneNumber as AnyObject?
        }

        if let restaurant = restaurant, let restaurantID = restaurant.id {
            userInfo["id"] = restaurantID as AnyObject?
        }

        activity.userInfo = userInfo

        activity.contentAttributeSet?.supportsNavigation = true
        activity.contentAttributeSet?.supportsPhoneCall = true

        super.updateUserActivityState(activity)
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

            self.prepareUserActivity()

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

                if self.headerImage != nil {
                    // TODO: étterem hero image beállítása
                } else {
                    self.headerView.heroImageView.alpha = 0
                    self.headerView.heroImageGradient.alpha = 0
                }

                self.headerView.titleLabel.text = restaurant.title
                self.headerView.yearLabel.text = restaurant.year

                if let rating = restaurant.rating {
                    let restaurantRating = RestaurantRating.init(points: rating)
                    let ratingView = RatingView.init(rating: restaurantRating, size: .badge)
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

            if headerImage != nil {
                let heroGradientAlpha = (420 + tableView.contentOffset.y) / 100

                if heroGradientAlpha >= 0 {
                    headerView.heroImageGradient.alpha = heroGradientAlpha
                    self.navigationController?.navigationBar.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: heroGradientAlpha)
                }
            }
        } else if tableView.contentOffset.y < -70 {
            switchNavigationBarAppearance(to: .transparent, updateTitle: true)
        } else {
            switchNavigationBarAppearance(to: .default, updateTitle: true)
        }

        headerView.frame = headerViewFrame
    }

    func switchNavigationBarAppearance(to appearance: NavigationBarAppearance, updateTitle: Bool = false) {
        switch appearance {
        case .default:
            navigationController?.navigationBar.layer.add(navigationBarAnimation, forKey: nil)
            UIView.animate(withDuration: 0.4, animations: {
                if let navigationController = self.navigationController as? WhiteNavigationViewController {
                    navigationController.state = .default

                    if updateTitle {
                        navigationController.navigationBar.topItem?.title = self.restaurant?.title
                    }
                }
            }, completion: nil)
        case .transparent:
            navigationController?.navigationBar.layer.add(navigationBarAnimation, forKey: nil)
            UIView.animate(withDuration: 0.4, animations: {
                if let navigationController = self.navigationController as? WhiteNavigationViewController {
                    if self.headerImage != nil {
                        navigationController.state = .transparent
                    }

                    if updateTitle {
                        navigationController.navigationBar.topItem?.title = ""
                    }
                }
            }, completion: nil)
        }
    }

    func dequeueResuableCell(for restaurantValue: Restaurant.RestaurantValue) -> UITableViewCell? {
        let actionColumns: [Restaurant.RestaurantValue.RestaurantColumn] = [.website, .address, .phone, .email, .facebookPage]
        if actionColumns.contains(restaurantValue.column) {
            return tableView.dequeueReusableCell(withIdentifier: "Value Action Cell")
        }

        return tableView.dequeueReusableCell(withIdentifier: "Value Cell")
    }

    func prepareUserActivity() {
        guard let restaurant = restaurant else { return }
        guard let uniqueIdentifier = restaurant.uniqueIdentifier else { return }

        if let coordinate = restaurant.calculateCoordinate() {
            let points = [MKMapPointForCoordinate(coordinate)]
            let mapRect = MKPolygon(points: points, count: 1).boundingMapRect
            let region = MKCoordinateRegionForMapRect(mapRect)
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = restaurant.address
            request.region = region

            let localSearch = MKLocalSearch(request: request)

            localSearch.start { (response, error) in
                guard error == nil else { return }
                guard let response = response else { return }
                guard let mapItem = response.mapItems.first else { return }

                let activity = NSUserActivity(activityType: "com.enfys.Restaurants.Detail")

                activity.isEligibleForHandoff = true
                activity.isEligibleForSearch = true
                activity.isEligibleForPublicIndexing = true

                activity.title = restaurant.title
                activity.contentAttributeSet?.relatedUniqueIdentifier = uniqueIdentifier

                mapItem.phoneNumber = restaurant.phone
                mapItem.name = restaurant.title
                mapItem.url = restaurant.website
                mapItem.phoneNumber = restaurant.phone
                mapItem.url = restaurant.website
                activity.mapItem = mapItem

                activity.delegate = self

                self.userActivity = activity
                self.userActivity?.becomeCurrent()
            }
        }
    }

    func stopUserActivity() {
        userActivity?.invalidate()
    }
}
