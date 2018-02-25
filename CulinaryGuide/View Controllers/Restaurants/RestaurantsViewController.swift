import UIKit

class RestaurantsViewController: UIViewController {
    @IBOutlet weak var filterBarButton: UIBarButtonItem!
    @IBOutlet weak var listContainerView: UIView!
    @IBOutlet weak var mapContainerView: UIView!

    let searchResultsController = UITableViewController.init()
    var searchController: UISearchController?
    var focusSearchBarOnLoad = false
    var restaurantFacets = [RestaurantFacet?]()
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

        definesPresentationContext = true
        
        // Setup searchBar
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController?.searchResultsUpdater = self
        searchController?.delegate = self
        searchController?.searchBar.delegate = self

        navigationItem.searchController = searchController

        searchResultsController.tableView.dataSource = self
        searchResultsController.tableView.delegate = self
        
        setSearchBarText()
        
        loadRestaurants()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if focusSearchBarOnLoad {
            searchController?.isActive = true
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
            searchController?.dismiss(animated: true)
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
            controller.filterState = RestaurantFilterState.init(queryTokens: queryTokens)
        }
    }
}

// MARK: - Searching

extension RestaurantsViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {
            if self.focusSearchBarOnLoad {
                self.searchController?.searchBar.becomeFirstResponder()
                self.focusSearchBarOnLoad = false
            }
        }
    }
}

extension RestaurantsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            Restaurant.facets(search: searchText) { restaurantFacets in
                self.restaurantFacets = restaurantFacets
                DispatchQueue.main.async {
                    self.searchResultsController.tableView.reloadData()
                }
            }
        }
    }
}

extension RestaurantsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        searchRestaurants(for: searchText)
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
            searchController?.searchBar.text = searchToken.value
            self.searchBarText = searchToken.value
        }
    }
}

extension RestaurantsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantFacets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "FacetCell")
        if let restaurantFacet = restaurantFacets[indexPath.row] {
            cell.tintColor = .black
            cell.textLabel?.text = restaurantFacet.value
            cell.imageView?.image = restaurantFacet.icon
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let restaurantFacet = restaurantFacets[indexPath.row] {
            guard let searchText = restaurantFacet.value else { return }
            searchRestaurants(for: searchText)
        }
    }
}

private extension RestaurantsViewController {
    func searchRestaurants(for query: String) {
        var newTokens = queryTokens
        newTokens.removeSearchTokens()
        newTokens.insert(URLQueryToken.init(column: "search", value: query))
        self.queryTokens = newTokens
    }
}
