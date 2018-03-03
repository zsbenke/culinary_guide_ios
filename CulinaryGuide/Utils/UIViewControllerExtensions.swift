//
//  About.swift
//  CulinaryGuide
//
//  Created by Benke Zsolt on 2018. 03. 03..
//  Copyright © 2018. Benke Zsolt. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {
    func presentAboutViewController() {
        if let aboutURL = URL(string: "http://gaultmillau.hu/rolunk") {
            let aboutViewController = SFSafariViewController(url: aboutURL)
            self.present(aboutViewController, animated: true, completion: nil)
        }
    }
}
