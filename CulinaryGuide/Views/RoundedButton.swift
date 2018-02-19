import UIKit

class RoundedButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.red
        self.contentEdgeInsets = UIEdgeInsets(top: 15.0, left: 25.0, bottom: 15.0, right: 25.0)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        setTitleColor(UIColor.BrandColor.light, for: .normal)
        setTitleColor(UIColor.BrandColor.lightHighlighted, for: .highlighted)
        setBackgroundImage(UIImage.imageWithColor(color: UIColor.BrandColor.primarySplashScreen), for: .normal)
        setBackgroundImage(UIImage.imageWithColor(color: UIColor.BrandColor.primarySplashScreenHighlighted), for: .highlighted)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
    }
}
