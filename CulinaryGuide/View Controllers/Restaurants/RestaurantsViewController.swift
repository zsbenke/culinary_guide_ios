import UIKit

class RestaurantsViewController: UIViewController {
    @IBOutlet weak var filterBarButton: UIBarButtonItem!
    @IBOutlet weak var listContainerView: UIView!
    @IBOutlet weak var mapContainerView: UIView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var focusSearchBarOnLoad = false
    var restaurants = [Restaurant?]()
    var initialRestaurants = [Restaurant?]()
    var searchBarText = ""
    
    var queryTokens = Set<URLQueryToken>() {
        didSet {
            var filterTokens = queryTokens
            filterTokens.removeSearchTokens()
            
            if filterTokens.isEmpty {
                filterBarButton.image = #imageLiteral(resourceName: "Toolbar Filter Icon")
            } else {
                filterBarButton.image = #imageLiteral(resourceName: "Toolbar Filter Icon Filled")
            }
            
            loadRestaurants()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup searchBar
        searchController.delegate = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        setSearchBarText()
        
        loadRestaurants()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if focusSearchBarOnLoad {
            searchController.isActive = true
        }
    }
    
    @IBAction func switchContainerViews(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            listContainerView.alpha = 1
            mapContainerView.alpha = 0
        } else {
            listContainerView.alpha = 0
            mapContainerView.alpha = 1
        }
    }
    
    func loadRestaurants(completionHandler: @escaping () -> Void = { }) {
        let restaurantsTableViewController = childViewControllers.filter {
            $0 is RestaurantsTableViewController
            }.first as? RestaurantsTableViewController
        let restaurantsMapViewController = childViewControllers.filter {
            $0 is RestaurantsMapViewController
            }.first as? RestaurantsMapViewController
        
        let prepareRestaurantsToChildViewControllers: () -> Void = {
            if let restaurantsTableViewController = restaurantsTableViewController {
                restaurantsTableViewController.restaurants = self.restaurants
            }
            if let restaurantsMapViewController = restaurantsMapViewController {
                restaurantsMapViewController.restaurants = self.restaurants
            }
        }
        
        if queryTokens.isEmpty {
            if initialRestaurants.isEmpty {
                Restaurant.index() { restaurants in
                    self.initialRestaurants = restaurants
                    self.restaurants = self.initialRestaurants
                    prepareRestaurantsToChildViewControllers()
                    completionHandler()
                }
            } else {
                self.restaurants = self.initialRestaurants
                prepareRestaurantsToChildViewControllers()
                completionHandler()
            }
        } else {
            searchController.dismiss(animated: true)
            Restaurant.index(search: Array(queryTokens)) { restaurants in
                self.restaurants = restaurants
                prepareRestaurantsToChildViewControllers()
                completionHandler()
            }
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFilter" {
            let controller = segue.destination.childViewControllers.first as! RestaurantFilterViewController
            controller.queryTokens = queryTokens
        }
    }
}

// MARK: - Searching

extension RestaurantsViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {
            if self.focusSearchBarOnLoad {
                self.searchController.searchBar.becomeFirstResponder()
                self.focusSearchBarOnLoad = false
            }
        }
    }
}

extension RestaurantsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        var newTokens = queryTokens
        newTokens.removeSearchTokens()
        newTokens.insert(URLQueryToken.init(column: "search", value: searchText))
        self.queryTokens = newTokens
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBarText.isEmpty {
            self.queryTokens.removeSearchTokens()
        } else {
            setSearchBarText()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let changedSearchBarText = searchBar.text else { return }
        self.searchBarText = changedSearchBarText
    }

    func setSearchBarText() {
        if let searchToken = queryTokens.searchToken() {
            searchController.searchBar.text = searchToken.value
            self.searchBarText = searchToken.value
        }
    }
}
