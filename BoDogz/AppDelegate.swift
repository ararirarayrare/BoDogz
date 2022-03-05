import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let mainVC = DogsViewController()
        let navVC = CustomNavigationController(rootViewController: mainVC)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navVC
        self.window?.makeKeyAndVisible()
                
        
        configureUserNotifications()
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    private func configureUserNotifications() {
      UNUserNotificationCenter.current().delegate = self
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void
  ) {
      completionHandler([.banner, .sound])
  }
}
