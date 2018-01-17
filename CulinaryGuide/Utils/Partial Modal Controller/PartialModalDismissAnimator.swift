import UIKit

class PartialModalDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let animationDuration = transitionDuration(using: transitionContext)
        
        fromViewController.view.transform = CGAffineTransform.identity
        fromViewController.view.clipsToBounds = true
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: .curveEaseIn, animations: {
            fromViewController.view.transform = CGAffineTransform.init(translationX: 0, y: fromViewController.view.bounds.height)
        }) { finished in
            fromViewController.view.removeFromSuperview()
            transitionContext.completeTransition(finished)
        }
    }
}

