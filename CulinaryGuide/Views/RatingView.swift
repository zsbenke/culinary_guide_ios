import UIKit

class RatingView: UIView {
    private struct DefaultRating: Rating {
        var points = ""
        var image = #imageLiteral(resourceName: "Rating Pop")
        var color = UIColor.BrandColor.primary
    }

    var rating: Rating

    init(rating: Rating) {
        self.rating = rating

        let frame = CGRect.init(x: 0.0, y: 0.0, width: 33, height: 29)
        super.init(frame: frame)

        self.backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        self.rating = DefaultRating()
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        let imageView = UIImageView.init(image: rating.image)
        imageView.backgroundColor = .white
        imageView.tintColor = rating.color
        imageView.contentMode = .scaleAspectFit
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)

        addSubview(imageView)
    }
}
