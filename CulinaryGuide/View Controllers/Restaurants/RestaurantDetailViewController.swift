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
    private var tableViewDataSource: RestaurantDataSource?
    private var headerImage: UIImage?
    private var headerView: DetailTitleView!
    private var headerViewHeight: CGFloat {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let baseHeight: CGFloat = 380.0
        guard statusBarHeight > 20 else { return baseHeight }
        return baseHeight + statusBarHeight
    }
    private let fadeAnimation = CATransition()

    override func viewDidLoad() {
        super.viewDidLoad()

        let backItem = UIBarButtonItem()
        navigationItem.backBarButtonItem = backItem

        tableView.dataSource = tableViewDataSource
        tableView.separatorStyle = .none

        navigationItem.largeTitleDisplayMode = .never
        tableView.contentInsetAdjustmentBehavior = .never

        fadeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        fadeAnimation.type = kCATransitionFade
        fadeAnimation.duration = 0.5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension RestaurantDetailViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataSource = tableView.dataSource as? RestaurantDataSource
        let section = dataSource?.getSection(for: indexPath.section)


        if section == RestaurantDataSource.Section.details, let detailRow = dataSource?.detailRows[indexPath.row] {
            if detailRow.column == .address {
                guard let address = restaurant?.address?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
                guard let mapsURL = URL(string: "http://maps.apple.com/?address=\(address)") else { return }
                UIApplication.shared.open(mapsURL, options: [:], completionHandler: nil)
            }

            if detailRow.column == .phone {
                guard let phone = restaurant?.phone?.filter({ "0123456789".contains($0) }) else { return }
                guard let phoneURL = URL(string: "tel:\(phone)") else { return }
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            }

            if detailRow.column == .website {
                guard let website = restaurant?.website else { return }
                UIApplication.shared.open(website, options: [:], completionHandler: nil)
            }

            if detailRow.column == .facebookPage {
                guard let facebookPage = restaurant?.facebookPage else { return }
                UIApplication.shared.open(facebookPage, options: [:], completionHandler: nil)
            }

            if detailRow.column == .email {
                guard let email = restaurant?.email else { return }
                guard let mailtoURL = URL(string: "mailto:\(email)") else { return }
                UIApplication.shared.open(mailtoURL, options: [:], completionHandler: nil)
            }
        }

        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
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

        super.updateUserActivityState(activity)
    }

    override func restoreUserActivityState(_ activity: NSUserActivity) {
        guard let userInfo = activity.userInfo else { return }

        if activity.activityType == CSSearchableItemActionType {
            if let selectedRestaurantID = userInfo[CSSearchableItemActivityIdentifier] as? String {
                restaurantID = Int(selectedRestaurantID)
            }
        } else if activity.activityType == "com.enfys.Restaurants.Detail" {
            if let selectedRstaurantID = userInfo["id"] as? Int {
                restaurantID = selectedRstaurantID
            }
        }
    }
}

private extension RestaurantDetailViewController {
    enum NavigationBarTitleState {
        case titleOff
        case titleOn
    }

    func configureView() {
        guard let restaurantID = restaurantID else { return }
        Restaurant.show(restaurantID) { restaurant in
            self.restaurant = restaurant

            self.prepareUserActivity()

            DispatchQueue.main.async {
                guard let restaurant = self.restaurant else { return }
                self.tableViewDataSource = RestaurantDataSource(restaurant: restaurant)
                self.tableView.dataSource = self.tableViewDataSource

                let headerViewFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: self.headerViewHeight)
                self.headerView = DetailTitleView.init(frame: headerViewFrame)

                self.headerView.titleLabel.text = restaurant.title
                self.headerView.yearLabel.text = restaurant.year

                if let rating = restaurant.rating {
                    let restaurantRating = RestaurantRating.init(points: rating)
                    let ratingView = RatingView.init(rating: restaurantRating, size: .badge)
                    self.headerView.ratingView.addSubview(ratingView)
                }

                self.tableView.tableHeaderView = nil
                self.tableView.addSubview(self.headerView)
                self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 24))
                self.tableView.separatorStyle = .singleLine

                self.tableView.contentInset = UIEdgeInsets(top: self.headerViewHeight, left: 0, bottom: 0, right: 0)
                self.tableView.contentOffset = CGPoint(x: 0, y: -self.headerViewHeight)

                self.updateHeaderView()

                self.tableView.reloadData()

                if let heroImageURL = restaurant.heroImageURL {
                    let operationQueue = OperationQueue()
                    let heroImageURLRequest = URLRequest(url: heroImageURL)
                    let requestOperation = APIRequestOperation(urlRequest: heroImageURLRequest)
                    requestOperation.completionBlock = {
                        guard let data = requestOperation.data else { return }

                        print("downloaded image data \(data)")

                        DispatchQueue.main.async {
                            let heroImage = UIImage(data: data)
                            self.headerImage = heroImage
                            self.headerView.layer.add(self.fadeAnimation, forKey: nil)

                            UIView.animate(withDuration: 0.5, animations: {
                                self.headerView.heroImageView.image = self.headerImage
                            })
                            self.updateHeaderView()
                        }
                    }
                    operationQueue.addOperation(requestOperation)
                }
            }
        }
    }

    func updateHeaderView() {
        var headerViewFrame = CGRect(x: 0, y: -headerViewHeight, width: tableView.bounds.width, height: headerViewHeight)

        if tableView.contentOffset.y <  -headerViewHeight {
            headerViewFrame.origin.y = tableView.contentOffset.y
            headerViewFrame.size.height = -tableView.contentOffset.y
        } else if tableView.contentOffset.y < -70 {
            switchNavigationBar(to: .titleOff)
        } else {
            switchNavigationBar(to: .titleOn)
        }

        headerView.frame = headerViewFrame
    }

    func switchNavigationBar(to titleState: NavigationBarTitleState) {
        switch titleState {
        case .titleOn:
            navigationController?.navigationBar.layer.add(fadeAnimation, forKey: nil)
            UIView.animate(withDuration: 0.4, animations: {
                self.navigationController?.navigationBar.topItem?.title = self.restaurant?.title
            }, completion: nil)
        case .titleOff:
            navigationController?.navigationBar.layer.add(fadeAnimation, forKey: nil)
            UIView.animate(withDuration: 0.4, animations: {
                self.navigationController?.navigationBar.topItem?.title = ""
            }, completion: nil)
        }
    }

    func prepareUserActivity() {
        guard let restaurant = restaurant else { return }
        guard let uniqueIdentifier = restaurant.uniqueIdentifier else { return }

        // Index with CoreSpotlight
        var searchableItems = [CSSearchableItem]()

        let searchableItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        searchableItemAttributeSet.title = restaurant.title
        searchableItemAttributeSet.contentDescription = restaurant.address
        searchableItemAttributeSet.relatedUniqueIdentifier = uniqueIdentifier

        if let phone = restaurant.phone { searchableItemAttributeSet.phoneNumbers = [phone] }

        if let coordinate = restaurant.calculateCoordinate() {
            searchableItemAttributeSet.latitude = NSNumber(value: Double(coordinate.latitude))
            searchableItemAttributeSet.longitude = NSNumber(value: Double(coordinate.longitude))
            searchableItemAttributeSet.supportsNavigation = true
        }

        let searchableItem = CSSearchableItem(uniqueIdentifier: uniqueIdentifier, domainIdentifier: "restaurants", attributeSet: searchableItemAttributeSet)
        searchableItems.append(searchableItem)
        CSSearchableIndex.default().indexSearchableItems(searchableItems) { (error) in
            if error == nil {
                print("indexed \(searchableItem.uniqueIdentifier)")
            }
        }

        // Prepare NSUserActivity
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
                activity.contentAttributeSet = searchableItemAttributeSet

                mapItem.phoneNumber = restaurant.phone
                mapItem.name = restaurant.title
                mapItem.url = restaurant.website
                mapItem.phoneNumber = restaurant.phone
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
