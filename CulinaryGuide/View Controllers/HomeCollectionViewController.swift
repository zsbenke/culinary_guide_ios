import UIKit

class HomeCollectionViewController: UICollectionViewController {
    var selectedQueryTokens = Set<URLQueryToken>()
    private var sizingCell: TagCollectionViewCell?
    private var cellSizes = [Int: [CGSize]]()
    private var collectionViewDataSource: HomeCollectionViewDataSource?

    enum HomeCollectionHeader: String, EnumCollection {
        case all
        case what
        case whatKindOf = "what_kind_of"
        case when
        case `where`

        func isEmpty(for facets: [RestaurantFacet?]) -> Bool {
            switch self {
                case .all:
                    return true
                case .what, .when, .where, .whatKindOf:
                guard let homeScreenSection = RestaurantFacet.HomeScreenSection(rawValue: self.rawValue) else { break }
                let facetsInSection = facets.filter(homeScreenSection: homeScreenSection)
                return facetsInSection.count == 0
            }

            return true
        }

        func asLocalized() -> String {
            switch self {
            case .all:
                return NSLocalizedString("Összes étterem…", comment: "Az főscreenen megjelenő összes étterem szekció címe.")
            case .what:
                return NSLocalizedString("Mit?", comment: "A főscreenen megjelenő mit szekció címe.")
            case .when:
                return NSLocalizedString("Mikor?", comment: "A főscreenen megjelenő mikor szekció címe.")
            case .where:
                return NSLocalizedString("Hol?", comment: "A főscreenen megjelenő mit szekció címe.")
            case .whatKindOf:
                return NSLocalizedString("Milyet?", comment: "A főscreenen megjelenő mit szekció címe.")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.dataSource = collectionViewDataSource

        sizingCell = ((UINib(nibName: "TagCollectionViewCell", bundle: nil).instantiate(withOwner: nil, options: nil) as Array).first as! TagCollectionViewCell)
        
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func configureView() {
        guard Localization.currentCountry != Localization.Country.Unknown else { return performSegue(withIdentifier: "chooseCountry", sender: self) }

        let currentCountry = Localization.currentCountry.name
        self.navigationItem.title = "\(currentCountry)"
        self.navigationController?.navigationBar.prefersLargeTitles = true

        Restaurant.facets { (facets) in
            DispatchQueue.main.async {
                self.cellSizes.removeAll()
                self.collectionViewDataSource = HomeCollectionViewDataSource(facets: facets)
                self.collectionView?.dataSource = self.collectionViewDataSource
                self.collectionView?.collectionViewLayout.invalidateLayout()
                self.collectionView?.reloadData()
            }
        }

        Restaurant.indexItems()
    }
    
    @IBAction func presentAbout(_ sender: Any) {
        presentAboutViewController()
    }

    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchRestaurants" {
            let restaurantsViewController = segue.destination as! RestaurantsViewController
            restaurantsViewController.queryTokens = selectedQueryTokens
        } else if segue.identifier == "focusOnSearchBar" {
            let restaurantsViewController = segue.destination as! RestaurantsViewController
            restaurantsViewController.presentSearchController = true
        }
    }
}

// MARK: UICollectionViev

extension HomeCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let collectionViewDataSource = collectionViewDataSource else { return }

        let facetSection = collectionViewDataSource.sections[indexPath.section]

        switch facetSection {
        case .all:
            self.selectedQueryTokens.removeAll()
            performSegue(withIdentifier: "searchRestaurants", sender: self)
        case .what, .when, .where, .whatKindOf:
            guard let facets = collectionViewDataSource.facetDictionary[facetSection] else { return }
            let facet = facets[indexPath.row]

            if let facetValue = facet.value {
                let queryToken = URLQueryToken.init(column: "search", value: facetValue)
                self.selectedQueryTokens = [queryToken]
                performSegue(withIdentifier: "searchRestaurants", sender: self)
            }
        }
    }
}

extension HomeCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let section = cellSizes[indexPath.section], section.indices.contains(indexPath.row) {
            return section[indexPath.row]
        }

        guard let collectionViewDataSource = collectionViewDataSource else { return CGSize(width: 0, height: 0) }

        let facetSection = collectionViewDataSource.sections[indexPath.section]
        var size = CGSize()

        collectionViewDataSource.configureCell(cell: sizingCell!, forIndexPath: indexPath)

        switch facetSection {
        case .all:
            var width = UIScreen.main.bounds.width
            if let cellMaxWidth = sizingCell?.labelViewMaxWidthConstraint.constant {
                width = cellMaxWidth
            }

            size = CGSize(width: width, height: 44)
        default:
            size = sizingCell!.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        }

        if cellSizes[indexPath.section] != nil {
            cellSizes[indexPath.section]?.insert(size, at: indexPath.row)
        } else {
            cellSizes[indexPath.section] = [size]
        }

        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let collectionViewDataSource = collectionViewDataSource else { return CGSize(width: 0, height: 0) }

        let facetSection = collectionViewDataSource.sections[section]

        if facetSection.isEmpty(for: collectionViewDataSource.facetDictionary) {
            return CGSize(width: UIScreen.main.bounds.width, height: 0)
        }

        return CGSize(width: UIScreen.main.bounds.width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let defaultInsets = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)

        guard let collectionViewDataSource = collectionViewDataSource else { return defaultInsets }

        let facetSection = collectionViewDataSource.sections[section]

        if facetSection == .all {
            return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        }

        if facetSection.isEmpty(for: collectionViewDataSource.facetDictionary) {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }

        return defaultInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
