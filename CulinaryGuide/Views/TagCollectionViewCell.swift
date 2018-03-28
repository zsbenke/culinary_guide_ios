import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var stackViewMaxWidthConstraint: NSLayoutConstraint!

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

        self.stackViewMaxWidthConstraint.constant = UIScreen.main.bounds.width - 8 * 2 - 8 * 2
    }
}
