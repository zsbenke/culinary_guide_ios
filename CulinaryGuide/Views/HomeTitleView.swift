import UIKit

class HomeTitleView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var heroImageGradient: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var ratedLabel: UILabel!
    @IBOutlet weak var alternativeLabel: UILabel!
    @IBOutlet weak var bestRatingView: UIView!

    @IBOutlet weak var leftSeparatorView: UIView!
    @IBOutlet weak var leftSeparatorWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightSeparatorView: UIView!
    @IBOutlet weak var rightSeparatorWidthConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }

    private func loadViewFromNib() {
        let borderThickness = 1 / UIScreen.main.scale
        Bundle.main.loadNibNamed("HomeTitleView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        leftSeparatorWidthConstraint.constant = borderThickness
        rightSeparatorWidthConstraint.constant = borderThickness
        leftSeparatorView.layoutIfNeeded()
        rightSeparatorView.layoutIfNeeded()

    }
}
