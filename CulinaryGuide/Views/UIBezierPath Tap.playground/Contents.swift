import PlaygroundSupport
import UIKit

class TestView: UIView {
    struct Action {
        static let didTap = #selector(TestView.didTap(recognizer:))
    }
    
    var tappedInside = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initTapGestureRecognizer()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initTapGestureRecognizer()

    }
    
    func initTapGestureRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Action.didTap)
        tapRecognizer.numberOfTapsRequired = 1
        self.isUserInteractionEnabled = true
        addGestureRecognizer(tapRecognizer)
    }
    
    override func draw(_ rect: CGRect) {
        let path = customPath()
        
        var fillColor = UIColor.yellow
        
        if tappedInside {
            fillColor = #colorLiteral(red: 0.745098054409027, green: 0.156862750649452, blue: 0.0745098069310188, alpha: 1.0)
        }
        
        fillColor.setFill()

        path.fill()
    }
    
    @objc func didTap(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: self)
        if customPath().contains(location) {
            self.tappedInside = true
        } else {
            self.tappedInside = false
        }
        
        setNeedsDisplay()

    }
    
    func customPath() -> UIBezierPath {
        var path = UIBezierPath()
        path.move(to: CGPoint(x: 100, y: 0))
        path.addLine(to: CGPoint(x: 200, y: 40))
        path.addLine(to: CGPoint(x: 160, y: 140))
        path.addLine(to: CGPoint(x: 40, y: 140))
        path.close()
        
        return path
    }
}

let view = TestView.init(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
view.backgroundColor = .white
PlaygroundPage.current.liveView = view
