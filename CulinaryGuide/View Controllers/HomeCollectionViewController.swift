import UIKit

class HomeCollectionViewController: UICollectionViewController {
    enum HomeCollectionHeader: String, EnumCollection {
        case all
        case what
        case when
        case `where`

        func asLocalized() -> String {
            switch self {
            case .all:
                return NSLocalizedString("Minden étterem", comment: "Az főscreenen megjelenő összes étterem szekció címe.")
            case .what:
                return NSLocalizedString("Mit?", comment: "A főscreenen megjelenő mit szekció címe.")
            case .when:
                return NSLocalizedString("Mikor?", comment: "A főscreenen megjelenő mikor szekció címe.")
            case .where:
                return NSLocalizedString("Hol?", comment: "A főscreenen megjelenő mit szekció címe.")
            }
        }
    }

    var selectedQueryTokens = Set<URLQueryToken>()
    var headerTitles = Array(HomeCollectionHeader.cases())
    var restaurantFacets = [RestaurantFacet?]()
    var sizingCell: TagCollectionViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tagCollectionCellNib = UINib(nibName: "TagCollectionViewCell", bundle: nil)
        let tagCollectionHeaderNib = UINib(nibName: "TagCollectionHeaderView", bundle: nil)
        collectionView!.register(tagCollectionCellNib, forCellWithReuseIdentifier: "TagCell")
        collectionView?.register(tagCollectionHeaderNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "TagHeader")
        
        self.sizingCell = ((tagCollectionCellNib.instantiate(withOwner: nil, options: nil) as Array).first as! TagCollectionViewCell)
        
        let currentCountry = Localization.currentCountry.name
        self.navigationItem.title = "\(currentCountry)"
        self.navigationController?.navigationBar.prefersLargeTitles = true

        Restaurant.facets { (facets) in
            self.restaurantFacets = facets
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchRestaurants" {
            let restaurantsViewController = segue.destination as! RestaurantsViewController
            restaurantsViewController.queryTokens = selectedQueryTokens
        } else if segue.identifier == "focusOnSearchBar" {
            let restaurantsViewController = segue.destination as! RestaurantsViewController
            restaurantsViewController.focusSearchBarOnLoad = true
        }
    }
    
    // MARK: UICollectionView
    
    
    func configureCell(cell: TagCollectionViewCell, forIndexPath indexPath: IndexPath) {
        let headerTitle = headerTitles[indexPath.section]
        switch headerTitle {
        case .all:
            break
        case .what, .when, .where:
            guard let homeScreenSection = RestaurantFacet.RestaurantHomeScreenSection(rawValue: headerTitle.rawValue) else { break }
            let facetsInSection = restaurantFacets.filter(homeScreenSection: homeScreenSection)

            guard let facet = facetsInSection[indexPath.row] else { break }
            cell.labelView.text = facet.value
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return headerTitles.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let headerTitle = headerTitles[section]
        switch headerTitle {
        case .all:
            return 0
        case .what, .when, .where:
            guard let homeScreenSection = RestaurantFacet.RestaurantHomeScreenSection(rawValue: headerTitle.rawValue) else { return 0 }
            let facetsInSection = restaurantFacets.filter(homeScreenSection: homeScreenSection)
            return facetsInSection.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> TagCollectionHeaderView {
        let tagHeaderCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TagHeader", for: indexPath) as? TagCollectionHeaderView
        let headerTitle = headerTitles[indexPath.section]
        tagHeaderCell?.titleLabel.text = headerTitle.asLocalized()
        return tagHeaderCell!
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TagCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCollectionViewCell
        
        configureCell(cell: cell, forIndexPath: indexPath)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let headerTitle = headerTitles[indexPath.section]

        switch headerTitle {
        case .all:
            break
        case .what, .when, .where:
            guard let homeScreenSection = RestaurantFacet.RestaurantHomeScreenSection(rawValue: headerTitle.rawValue) else { break }
            let facetsInSection = restaurantFacets.filter(homeScreenSection: homeScreenSection)
            if let facet = facetsInSection[indexPath.row], let facetValue = facet.value {
                let queryToken = URLQueryToken.init(column: "search", value: facetValue)
                self.selectedQueryTokens = [queryToken]
                performSegue(withIdentifier: "searchRestaurants", sender: self)
            }
        }
    }
}

extension HomeCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.configureCell(cell: sizingCell!, forIndexPath: indexPath)
        return sizingCell!.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 50)
    }
}
