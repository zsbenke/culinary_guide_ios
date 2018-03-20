import UIKit

class HomeTitleView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var heroImageGradient: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var ratedLabel: UILabel!
    @IBOutlet weak var alternativeLabel: UILabel!
    @IBOutlet weak var bestRatingView: UIView!

    @IBOutlet weak private var statStackView: UIStackView!
    @IBOutlet weak private var ratedStatView: UIView!
    @IBOutlet weak private var bestRatingStatView: UIView!
    @IBOutlet weak private var alternativeStatView: UIView!
    @IBOutlet weak private var separatorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var separator: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }

    private func loadViewFromNib() {
        Bundle.main.loadNibNamed("HomeTitleView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        separatorHeightConstraint.constant = 1.0 / UIScreen.main.scale
        separator.layoutIfNeeded()
    }
}
