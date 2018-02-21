import UIKit

class TagCollectionHeaderView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separator: UIView!
    
    override func awakeFromNib() {
        titleLabel.textColor = UIColor.BrandColor.facetText
    }
}
