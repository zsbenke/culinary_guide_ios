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
        let ratio = UIScreen.main.bounds.width / 4
        let baseHeight: CGFloat = ratio * 3.5
        guard statusBarHeight > 20 else { return baseHeight }
        return baseHeight + statusBarHeight
    }
    private let fadeAnimation = CATransition()

    lazy var previewActions: [UIPreviewActionItem] = {
        let openAddressTitle = NSLocalizedString("Megnyitás a Térképekkel", comment: "3D touch action ami megnyitja az éttermet a Térképek alkalmazásban.")
        let openAddressAction = UIPreviewAction(title: openAddressTitle, style: .default) { (action, viewController) in
            self.openAddress()
        }

        let callTitle = NSLocalizedString("Hívás telefonon", comment: "3D touch action ami felhívja az éttermet.")
        let callAction = UIPreviewAction(title: callTitle, style: .default) { (action, viewController) in
            self.call()
        }

        let openWebsiteTitle = NSLocalizedString("Webhely felkeresése", comment: "3D touch action ami megnyitja az éttermet a Térképek alkalmazásban.")
        let openWebsiteAction = UIPreviewAction(title: openWebsiteTitle, style: .default) { (action, viewController) in
            self.openWebsite()
        }

        return [openAddressAction, callAction, openWebsiteAction]
    }()

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

    override var previewActionItems: [UIPreviewActionItem] {
        return previewActions
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let navigationController = self.navigationController as? PlainNavigationViewController {
            navigationController.state = .transparent
        }
    }

    func setRestaurantID(from userInfo: [AnyHashable: Any]) {
        if let selectedRstaurantID = userInfo["id"] as? Int {
            restaurantID = selectedRstaurantID
        }
    }
}

extension RestaurantDetailViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataSource = tableView.dataSource as? RestaurantDataSource
        let section = dataSource?.getSection(for: indexPath.section)


        if section == RestaurantDataSource.Section.details, let detailRow = dataSource?.detailRows[indexPath.row] {
            if detailRow.column == .address {
                openAddress()
            }

            if detailRow.column == .phone {
                call()
            }

            if detailRow.column == .website {
                openWebsite()
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
            setRestaurantID(from: userInfo)
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

                if let title = restaurant.title {
                    let shortcuts = UIApplication.shared.shortcutItems
                    var userInfo = [String: AnyObject]()
                    userInfo["id"] = restaurantID as AnyObject?

                    let restaurantShortcut = UIApplicationShortcutItem(
                        type: "\(AppDelegate.ShortcutItemType.restaurant)",
                        localizedTitle: NSLocalizedString("Legutóbbi étterem", comment: "3D touch shortcut action"),
                        localizedSubtitle: title,
                        icon: UIApplicationShortcutIcon(type: .bookmark),
                        userInfo: userInfo
                    )

                    if let searchShortcut = shortcuts?.first {
                        UIApplication.shared.shortcutItems = [searchShortcut, restaurantShortcut]
                    }
                }

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

    func switchNavigationBarAppearance(to appearance: PlainNavigationViewController.NavigationBarState, updateTitle: Bool = false) {
        switch appearance {
        case .default:
            navigationController?.navigationBar.layer.add(fadeAnimation, forKey: nil)
            UIView.animate(withDuration: 0.4, animations: {
                if let navigationController = self.navigationController as? PlainNavigationViewController {
                    navigationController.state = .default

                    if updateTitle {
                        navigationController.navigationBar.topItem?.title = self.restaurant?.title
                    }
                }
            }, completion: nil)
        case .transparent:
            navigationController?.navigationBar.layer.add(fadeAnimation, forKey: nil)
            UIView.animate(withDuration: 0.4, animations: {
                if let navigationController = self.navigationController as? PlainNavigationViewController {
                    navigationController.state = .transparent

                    if updateTitle {
                        navigationController.navigationBar.topItem?.title = ""
                    }
                }
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

    func openAddress() {
        guard let address = restaurant?.address?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let mapsURL = URL(string: "http://maps.apple.com/?address=\(address)") else { return }
        UIApplication.shared.open(mapsURL, options: [:], completionHandler: nil)
    }

    func openWebsite() {
        guard let website = restaurant?.website else { return }
        UIApplication.shared.open(website, options: [:], completionHandler: nil)
    }

    func call() {
        guard let phone = restaurant?.phone?.filter({ "0123456789".contains($0) }) else { return }
        guard let phoneURL = URL(string: "tel:\(phone)") else { return }
        UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
    }
}
