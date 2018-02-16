import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var labelViewMaxWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor(red: 0.91, green: 0.91, blue: 0.92, alpha:1.0)
        self.labelViewMaxWidthConstraint.constant = UIScreen.main.bounds.width - 8 * 2 - 8 * 2
    }
}
