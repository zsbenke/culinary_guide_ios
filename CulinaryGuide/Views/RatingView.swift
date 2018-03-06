import UIKit

class RatingView: UIView {
    var rating: Rating
    private var frameFromSize = CGRect.init(x: 0.0, y: 0.0, width: 33, height: 29)

    enum RatingViewSize {
        case `default`
        case badge
    }

    init(rating: Rating, size: RatingViewSize = .default) {
        self.rating = rating

        if size == .badge {
            frameFromSize.size.width = 52
            frameFromSize.size.height = 46
        }

        super.init(frame: frameFromSize)
        backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.0)
    }

    required init?(coder aDecoder: NSCoder) {
        self.rating = DefaultRating()
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        let imageView = UIImageView.init(image: rating.image)
        imageView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.0)
        imageView.tintColor = rating.color
        imageView.contentMode = .scaleAspectFit
        imageView.frame = frameFromSize
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)

        addSubview(imageView)
    }
}

private extension RatingView {
    struct DefaultRating: Rating {
        var points = ""
        var image = #imageLiteral(resourceName: "Rating Pop")
        var color = UIColor.BrandColor.secondaryRating
        var isSecondary = true
    }
}
