import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //    if Localization.currentCountry != Localization.Country.Unknown {
        //      let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //      let restaurantsViewController = storyboard.instantiateViewController(withIdentifier: "RestaurantsViewController") as! RestaurantsViewController
        //      let rootViewController = self.window!.rootViewController as! UINavigationController
        //      rootViewController.pushViewController(restaurantsViewController, animated: false)
        //    }
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
        if let userInfo = userActivity.userInfo {
            if let restaurantID = userInfo["id"] as? Int {
                if Localization.currentCountry != Localization.Country.Unknown {
                    let rootViewController = self.window!.rootViewController as! UINavigationController

                    if rootViewController.topViewController is RestaurantDetailViewController {
                        guard let restaurantDetailViewController = rootViewController.topViewController as? RestaurantDetailViewController else { return true }
                        if restaurantDetailViewController.restaurantID == restaurantID { return true }
                        rootViewController.popViewController(animated: true)
                    }

                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let restaurantDetailViewController = storyboard.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
                    restaurantDetailViewController.restaurantID = restaurantID
                    rootViewController.pushViewController(restaurantDetailViewController, animated: true)
                }
            }
        }
        return true
    }
}
