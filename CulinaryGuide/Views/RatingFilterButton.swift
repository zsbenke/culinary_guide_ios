
import UIKit

final class RatingFilterButton: UIControl {
    var rating: Rating
    var isOn = false {
        didSet {
            if isOn {
                backgroundColor = UIColor.BrandColor.ratingFilterOn
            } else {
                backgroundColor = UIColor.BrandColor.ratingFilterOff
            }
        }
    }
    override var isHighlighted: Bool {
        didSet {
            if isOn {
                backgroundColor = UIColor.BrandColor.ratingFilterOnHighlighted
            } else {
                backgroundColor = UIColor.BrandColor.ratingFilterOffHighlighted
            }
        }
    }

    private let generator = UIImpactFeedbackGenerator(style: .light)
    private struct DefaultRating: Rating {
        var points = ""
        var image = #imageLiteral(resourceName: "Rating Pop")
        var color = UIColor.white
    }

    init(rating: Rating) {
        self.rating = rating

        let frame = CGRect.init(x: 0.0, y: 0.0, width: 44, height: 44)
        super.init(frame: frame)

        clipsToBounds = true
        backgroundColor = UIColor.BrandColor.ratingFilterOff
        layer.cornerRadius = 5
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = false
        generator.prepare()
    }

    required init?(coder aDecoder: NSCoder) {
        self.rating = DefaultRating()
        super.init(coder: aDecoder)
        generator.prepare()
    }

    override func draw(_ rect: CGRect) {
        let imageView = UIImageView.init(image: rating.image)
        imageView.backgroundColor = UIColor.clear
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.center = self.center
        imageView.isUserInteractionEnabled = false

        addSubview(imageView)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = true
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false

        if isOn {
            isOn = false
        } else {
            isOn = true
        }

        generator.impactOccurred()

        sendActions(for: .valueChanged)
    }
}
