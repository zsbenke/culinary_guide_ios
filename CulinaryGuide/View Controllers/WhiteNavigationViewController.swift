//
//  WhiteNavigationViewController.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 02. 25..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit

class WhiteNavigationViewController: UINavigationController {
    enum NavigationBarState {
        case `default`
        case transparent
    }

    private let emptyImage = UIImage()
    private let whiteImage = UIImage.fromColor(.white)

    var state: NavigationBarState = .default {
        didSet {
            switch state {
            case .default:
                navigationBar.setBackgroundImage(nil, for: .default)
                UIApplication.shared.statusBarStyle = .default
                navigationBar.shadowImage = emptyImage
                navigationBar.barTintColor = .white
                navigationBar.tintColor = UIColor.BrandColor.primary
            case .transparent:
                UIApplication.shared.statusBarStyle = .lightContent
                navigationBar.setBackgroundImage(emptyImage, for: .default)
                navigationBar.shadowImage = emptyImage
                navigationBar.barTintColor = nil
                navigationBar.tintColor = .white
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension WhiteNavigationViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        toggleState(for: viewController)
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        toggleState(for: viewController)
    }
}

private extension WhiteNavigationViewController {
    func toggleState(for viewController: UIViewController) {
        if viewController is SplashViewController {
            state = .transparent
            UIApplication.shared.statusBarStyle = .default
        } else if viewController is RestaurantDetailViewController {
            state = .transparent
        } else {
            state = .default
        }
    }
}
