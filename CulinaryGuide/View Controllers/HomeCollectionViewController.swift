//
//  HomeCollectionViewController.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 01. 13..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class HomeCollectionViewController: UICollectionViewController {
  var selectedQueryTokens = Set<URLQueryToken>()
  var tagHeaderTitles = [String]()
  var tags = [
    "Mit?": ["bbq", "bor", "grill", "hal", "pékség", "pizza", "seafood", "sör", "steak"],
    "Mikor?": ["ebédmenü", "vasárnapi brunch"],
    "Hol?": ["kerthelyiség", "terasz", "reggeli", "panorámás"],
    "Milyen?": ["ázsiai", "bisztró", "büfé", "delikát bolt", "erdélyi", "fine dining", "francia", "fúziós", "gyerekbarát", "horvát", "magyar", "mediterrán", "nemzetközi", "olasz", "román", "szerb", "szlovák", "szlovén", "újító", "vegetáriánus"]
  ]
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

    self.tagHeaderTitles = Array(tags.keys)
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
    let tagHeader = Array(tags.keys)[indexPath.section]
    let tagsInSection = tags[tagHeader]
    if let tagsInSection = tagsInSection {
      let tag = tagsInSection[indexPath.row]
      cell.labelView.text = tag
    }
  }

  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return tagHeaderTitles.count
  }


  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let tagHeader = Array(tags.keys)[section]
    let tagsInSection = tags[tagHeader]
    if let tagsInSection = tagsInSection {
      return tagsInSection.count
    } else {
      return 0
    }
  }

  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> TagCollectionHeaderView {
    let tagHeaderCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TagHeader", for: indexPath) as? TagCollectionHeaderView
    let tagHeader = tagHeaderTitles[indexPath.section]
    tagHeaderCell?.titleLabel.text = tagHeader
    return tagHeaderCell!
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: TagCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCollectionViewCell

    configureCell(cell: cell, forIndexPath: indexPath)
    return cell
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let tagHeader = Array(tags.keys)[indexPath.section]
    let tagsInSection = tags[tagHeader]
    if let tagsInSection = tagsInSection {
      let tag = tagsInSection[indexPath.row]
      let queryToken = URLQueryToken.init(column: "search", value: tag)
      self.selectedQueryTokens = [queryToken]
      performSegue(withIdentifier: "searchRestaurants", sender: self)
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
