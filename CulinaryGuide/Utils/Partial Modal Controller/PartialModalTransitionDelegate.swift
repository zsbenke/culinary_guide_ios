import UIKit

class PartialModalTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var modalHeight: CGFloat = 200
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let partialModalPresentationController = PartialModalPresentationController(presentedViewController: presented, presenting: presenting)
        partialModalPresentationController.height = modalHeight
        return partialModalPresentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PartialModalPresentationAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PartialModalDismissAnimator()
    }
}
