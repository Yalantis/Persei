// For License please refer to LICENSE file in the root of Persei project

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let appearance = UINavigationBar.appearance()
        appearance.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "TrendSansOne", size: 20)!,
            NSForegroundColorAttributeName: UIColor(red: 44 / 255, green: 49 / 255, blue: 51 / 255, alpha: 1)
        ]
        
        return true
    }
}
