import UIKit

class TagCollectionHeaderView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var separatorHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        separatorHeightConstraint.constant = 1.0 / UIScreen.main.scale
        separator.layoutIfNeeded()
    }
}
