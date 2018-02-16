import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var labelViewMaxWidthConstraint: NSLayoutConstraint!

    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = UIColor.BrandColor.facetSelected
            } else {
                self.backgroundColor = UIColor.BrandColor.facet
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor.BrandColor.facet
        self.labelViewMaxWidthConstraint.constant = UIScreen.main.bounds.width - 8 * 2 - 8 * 2
    }
}
