import UIKit

class HomeTitleView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var heroImageGradient: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var ratedLabel: UILabel!
    @IBOutlet weak var alternativeLabel: UILabel!
    @IBOutlet weak var bestRatingBadgeView: UIView!
    @IBOutlet weak var allRestaurantsButton: UIButton!

    @IBOutlet weak var ratedView: UIView!
    @IBOutlet weak var bestRatingView: UIView!
    @IBOutlet weak var alternativeView: UIView!
    
    @IBOutlet weak private var leftSeparatorView: UIView!
    @IBOutlet weak private var leftSeparatorWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak private var rightSeparatorView: UIView!
    @IBOutlet weak private var rightSeparatorWidthConstraint: NSLayoutConstraint!

    @IBOutlet var ratedTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var bestRatingGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var alternativeGestureRecognizer: UITapGestureRecognizer!

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
