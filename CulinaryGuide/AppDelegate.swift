import UIKit
import CoreSpotlight

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    enum ShortcutItemType: String {
        case search
        case nearby
        case restaurant
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let searchAction = UIMutableApplicationShortcutItem(type: "\(ShortcutItemType.search)",
            localizedTitle: NSLocalizedString("Keresés", comment: "3D touch shortcut action"),
            localizedSubtitle: nil,
            icon: UIApplicationShortcutIcon(type: .search),
            userInfo: nil
        )

//        let nearbyAction = UIMutableApplicationShortcutItem(type: "\(ShortcutItemType.nearby)",
//            localizedTitle: NSLocalizedString("Éttermek a környéken", comment: "3D touch shortcut action"),
//            localizedSubtitle: nil,
//            icon: UIApplicationShortcutIcon(type: .location),
//            userInfo: nil
//        )

        application.shortcutItems = [searchAction]

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        popRestaurantDetailViewController { viewController in
            viewController.restoreUserActivityState(userActivity)
        }

        return true
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        switch shortcutItem.type {
        case "\(ShortcutItemType.search)":
            let rootViewController = self.window!.rootViewController as! UINavigationController
            rootViewController.popToRootViewController(animated: false)

            if let homeCollectionViewController = rootViewController.topViewController as? HomeCollectionViewController {
                homeCollectionViewController.performSegue(withIdentifier: "focusOnSearchBar", sender: self)
            }
        case "\(ShortcutItemType.restaurant)":
            guard let userInfo = shortcutItem.userInfo else { return completionHandler(true) }
            popRestaurantDetailViewController { viewController in
                viewController.setRestaurantID(from: userInfo)
            }
        default:
            break
        }
        completionHandler(true)
    }
}

private extension AppDelegate {
    func popRestaurantDetailViewController(completionHandler: (RestaurantDetailViewController) -> Void) {
        let rootViewController = self.window!.rootViewController as! UINavigationController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let restaurantDetailViewController = storyboard.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
        if rootViewController.topViewController is RestaurantDetailViewController {
            rootViewController.popViewController(animated: false)
        }
        rootViewController.pushViewController(restaurantDetailViewController, animated: true)
        completionHandler(restaurantDetailViewController)
    }
}
