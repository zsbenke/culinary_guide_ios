import UIKit

class HomeCollectionViewController: UICollectionViewController {
    var selectedQueryTokens = Set<URLQueryToken>()
    private var sizingCell: TagCollectionViewCell?
    private var cellSizes = [Int: [CGSize]]()
    private var restaurants = [Restaurant?]()
    private var collectionViewDataSource: HomeCollectionViewDataSource?
    private var headerView: HomeTitleView!
    private var headerViewHeight: CGFloat {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let ratio = UIScreen.main.bounds.width / 4
        let baseHeight: CGFloat = ratio * 3.5
        guard statusBarHeight > 20 else { return baseHeight }
        return baseHeight + statusBarHeight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.title = ""

        collectionView?.dataSource = collectionViewDataSource
        collectionView?.contentInsetAdjustmentBehavior = .never

        sizingCell = ((UINib(nibName: "TagCollectionViewCell", bundle: nil).instantiate(withOwner: nil, options: nil) as Array).first as! TagCollectionViewCell)

        setCurrentCountryHeroImage()
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateNavigationBarAppearance(animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateNavigationBarAppearance(animated: false)

        if let headerView = headerView {
            for view in [headerView.ratedView, headerView.bestRatingView, headerView.alternativeView] {
                guard let view = view else { continue }
                setHighlightAppearance(view, highlighted: false)
            }
        }
    }

    func configureView() {
        guard Localization.currentCountry != Localization.Country.Unknown else { return performSegue(withIdentifier: "chooseCountry", sender: self) }

        Restaurant.facets { (facets) in
            DispatchQueue.main.async {
                self.cellSizes.removeAll()
                self.collectionViewDataSource = HomeCollectionViewDataSource(facets: facets)
                self.collectionView?.dataSource = self.collectionViewDataSource
                self.collectionView?.collectionViewLayout.invalidateLayout()
                self.collectionView?.reloadData()

                Restaurant.index { restaurants in
                    self.restaurants = restaurants
                    Restaurant.updateSpotlightIndex(items: restaurants)

                    self.setCurrentCountryHeroImage()
                }
            }
        }
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

extension HomeCollectionViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
}

private extension HomeCollectionViewController {
    func setCurrentCountryHeroImage() {
        DispatchQueue.main.async {
            if self.headerView == nil {
                let headerViewFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: self.headerViewHeight)
                self.headerView = HomeTitleView.init(frame: headerViewFrame)
                self.headerView.ratedTapGestureRecognizer.addTarget(self, action: #selector(self.tappedRatedStatisics(_:)))
                self.headerView.bestRatingGestureRecognizer.addTarget(self, action: #selector(self.tappedBestRatingStatistics(_:)))
                self.headerView.alternativeGestureRecognizer.addTarget(self, action: #selector(self.tappedAlternativeStatistics(_:)))
            }

            self.headerView.heroImageView.image = Localization.currentCountry.homeHeroImage
            self.headerView.countryNameLabel.text = Localization.currentCountry.name

            self.collectionView?.subviews.filter { $0.isKind(of: HomeTitleView.self) }.first?.removeFromSuperview()
            self.collectionView?.addSubview(self.headerView)
            self.collectionView?.contentInset = UIEdgeInsets(top: self.headerViewHeight, left: 0, bottom: self.navigationController?.toolbar.frame.height ?? 0, right: 0)
            self.collectionView?.contentOffset = CGPoint(x: 0, y: -self.headerViewHeight)
            self.updateHeaderView(animated: false)

            if !self.restaurants.isEmpty {
                if let maxRating = self.restaurants.compactMap({ $0 }).maxRating() {
                    let ratingView = RatingView.init(rating: maxRating)

                    for view in self.headerView.bestRatingBadgeView.subviews {
                        view.removeFromSuperview()
                    }
                    self.headerView.bestRatingBadgeView.addSubview(ratingView)
                }

                self.headerView.ratedLabel.text = String(describing: self.restaurants.compactMap { $0 }.filter { $0.rating != "pop" }.count)
                self.headerView.alternativeLabel.text = String(describing: self.restaurants.compactMap { $0 }.filter { $0.rating == "pop" }.count)
            }
        }
    }

    func updateHeaderView(animated: Bool = true) {
        guard let collectionView = collectionView else { return }
        var headerViewFrame = CGRect(x: 0, y: -headerViewHeight, width: collectionView.bounds.width, height: headerViewHeight)

        if collectionView.contentOffset.y <  -headerViewHeight {
            headerViewFrame.origin.y = collectionView.contentOffset.y
            headerViewFrame.size.height = -collectionView.contentOffset.y

            let heroGradientAlpha = 1 - abs(headerViewHeight + collectionView.contentOffset.y) / 100

            if heroGradientAlpha >= 0 {
                headerView.heroImageGradient.alpha = heroGradientAlpha
                self.navigationController?.navigationBar.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: heroGradientAlpha)
            }
        }

        updateNavigationBarAppearance(animated: animated)
        headerView.frame = headerViewFrame
    }

    func updateNavigationBarAppearance(animated: Bool) {
        guard let collectionView = collectionView else { return }

        func setNavigationBarToDefault() {
            if let navigationController = self.navigationController as? PlainNavigationViewController {
                navigationController.state = .default
                navigationController.navigationBar.topItem?.title = "\(Localization.currentCountry.name)"
            }
        }

        func setNavigationBarToTransparent() {
            if let navigationController = self.navigationController as? PlainNavigationViewController {
                navigationController.state = .transparent
                navigationController.navigationBar.topItem?.title = ""
            }
        }

        if collectionView.contentOffset.y < -151 {
            if animated {
                UIView.animate(withDuration: 0.4, animations: {
                    setNavigationBarToTransparent()
                }, completion: nil)
            } else {
                setNavigationBarToTransparent()
            }
        } else {
            if animated {
                UIView.animate(withDuration: 0.4, animations: {
                    setNavigationBarToDefault()
                }, completion: nil)
            } else {
                setNavigationBarToDefault()
            }
        }
    }

    @objc func tappedRatedStatisics(_ sender: Any) {
        setHighlightAppearance(headerView.ratedView, highlighted: true)
        performSegue(withIdentifier: "searchRestaurants", sender: self)
    }

    @objc func tappedBestRatingStatistics(_ sender: Any) {
        guard let maxRating = restaurants.compactMap({ $0 }).maxRating() else { return }

        setHighlightAppearance(headerView.bestRatingView, highlighted: true)
        let queryToken = URLQueryToken.init(column: "rating", value: maxRating.points)
        self.selectedQueryTokens = [queryToken]
        performSegue(withIdentifier: "searchRestaurants", sender: self)
    }

    @objc func tappedAlternativeStatistics(_ sender: Any) {
        setHighlightAppearance(headerView.alternativeView, highlighted: true)
        let queryToken = URLQueryToken.init(column: "rating", value: "pop")
        self.selectedQueryTokens = [queryToken]
        performSegue(withIdentifier: "searchRestaurants", sender: self)
    }

    func setHighlightAppearance(_ view: UIView, highlighted: Bool) {
        view.backgroundColor = highlighted ? UIColor.BrandColor.facet : .white
    }
}
