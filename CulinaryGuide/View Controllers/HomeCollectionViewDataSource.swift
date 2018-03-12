import UIKit

class HomeCollectionViewDataSource: NSObject {
    typealias FacetDictionary = [Section: Array<RestaurantFacet>]

    enum Section: String, EnumCollection {
        case all
        case what
        case whatKindOf = "what_kind_of"
        case when
        case `where`

        func isEmpty(for facetDictionary: FacetDictionary) -> Bool {
            switch self {
            case .all:
                return true
            case .what, .when, .where, .whatKindOf:
                guard let facets = facetDictionary[self] else { return true }
                return facets.count == 0
            }
        }

        func asLocalized() -> String {
            switch self {
            case .all:
                return NSLocalizedString("All Restaurants…", comment: "Az főscreenen megjelenő összes étterem szekció címe.")
            case .what:
                return NSLocalizedString("What?", comment: "A főscreenen megjelenő mit szekció címe.")
            case .when:
                return NSLocalizedString("When?", comment: "A főscreenen megjelenő mikor szekció címe.")
            case .where:
                return NSLocalizedString("Where?", comment: "A főscreenen megjelenő mit szekció címe.")
            case .whatKindOf:
                return NSLocalizedString("What Kind Of?", comment: "A főscreenen megjelenő mit szekció címe.")
            }
        }
    }

    var facetDictionary: FacetDictionary = [
        .all: [],
        .what: [],
        .whatKindOf: [],
        .when: [],
        .where: []
    ]
    var sections = Array(Section.cases())

    private let tagCollectionCellNib = UINib(nibName: "TagCollectionViewCell", bundle: nil)
    private let tagCollectionHeaderNib = UINib(nibName: "TagCollectionHeaderView", bundle: nil)
    private var isTagCollectionCellNibRegistered = false
    private var isTagCollectionHeaderCellNibRegistered = false

    init(facets: [RestaurantFacet?]) {
        for facet in facets {
            guard let facet = facet else { continue }
            guard let section = Section(rawValue: facet.homeScreenSection.rawValue) else { continue }
            guard let facets = facetDictionary[section] else { continue }

            if facets.contains(facet) {
                continue
            } else {
                facetDictionary[section]?.append(facet)
            }
        }
    }

    func configureCell(cell: TagCollectionViewCell, forIndexPath indexPath: IndexPath) {
        let facetSection = sections[indexPath.section]
        switch facetSection {
        case .all:
            cell.labelView.text = facetSection.asLocalized()
            cell.labelView.textAlignment = .center
        case .what, .when, .where, .whatKindOf:
            guard let facets = facetDictionary[facetSection] else { break }

            let facet = facets[indexPath.row]
            cell.labelView.text = facet.value
        }
    }
}

extension HomeCollectionViewDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let facetSection = sections[section]
        switch facetSection {
        case .all:
            return 1
        case .what, .when, .where, .whatKindOf:
            guard let facets = facetDictionary[facetSection] else { break }
            return facets.count
        }

        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if !isTagCollectionCellNibRegistered {
            collectionView.register(tagCollectionCellNib, forCellWithReuseIdentifier: "TagCell")
            isTagCollectionCellNibRegistered = true
        }

        let cell: TagCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCollectionViewCell
        configureCell(cell: cell, forIndexPath: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if !isTagCollectionHeaderCellNibRegistered {
            collectionView.register(tagCollectionHeaderNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "TagHeader")
            isTagCollectionHeaderCellNibRegistered = true
        }

        let facetHeaderCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TagHeader", for: indexPath) as? TagCollectionHeaderView
        let facetSection = sections[indexPath.section]
        facetHeaderCell?.titleLabel.text = facetSection.asLocalized()

        if facetSection.isEmpty(for: facetDictionary) {
            facetHeaderCell?.isHidden = true

        }
        return facetHeaderCell!
    }
}
