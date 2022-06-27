//
//  AppDelegate.swift
//  CloseChannelClient
//
//  Created by Close BV de Bijl on 3/24/22.
//

import UIKit
import CloseChannel

extension UIApplication {
    static var mainWindow: UIWindow? {
        return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var pushToken: String?

    let closeChannelController = CloseChannelController.sharedInstance

    let tabBarController = UITabBarController()
    var channelsTableViewController: ChannelsTableViewController?

    private func createSymLink() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("**** Documents path: \(documentsPath)")
        let pathComponents = documentsPath.components(separatedBy: "/")
        let linkFile = pathComponents[1] + "/" + pathComponents[2] + "/Desktop/CloseChannelSdkClient Simulator Container"

        _ = try? FileManager().removeItem(atPath: linkFile)
        _ = try? FileManager().createSymbolicLink(atPath: linkFile,
                                              withDestinationPath: documentsPath)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        createSymLink()
        registerForPushNotifications()

        return true
    }

    fileprivate func registerForPushNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self

        notificationCenter.requestAuthorization(options: [.badge, .alert, .sound]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications() // this will call didRegisterForRemoteNotificationsWithDeviceToken when successful
                }
            } else {
                self.closeChannelController.registerPushInfo(token: nil,
                                                             permissionGranted: false) { isPushEnabled in
                    print("Unregistered because permission not granted")
                } failure: { error in
                    print("Failed to unregister")
                }
            }
        }
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

}


// - Handling push notifications
extension AppDelegate: UNUserNotificationCenterDelegate {

    // When successfully registered for push notifications
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let pushToken = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        self.pushToken = pushToken
        self.closeChannelController.registerPushInfo(token: pushToken,
                                                     permissionGranted: true) { isPushEnabled in
            if isPushEnabled {
                print("Successfully registered for push notifications with token  \(pushToken)")
            }
        } failure: { error in
            print("Failed to register for push notifications: \(error)")
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for push notifications: \(error)")

        self.closeChannelController.registerPushInfo(token: nil,
                                                     permissionGranted: false) { isPushEnabled in
            print("Unregistered because permission not granted")
        } failure: { error in
            print("Failed to unregister")
        }
    }

    // Notification received when app is active, we can show it here
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        let userInfo = notification.request.content.userInfo
        if let closeChannelNotification = CloseChannelNotification.from(userInfo: userInfo) {
            print("Notification received: \(closeChannelNotification.message ?? "")")

            // Let the OS handle the notification...
            completionHandler([.alert, .sound])

            // (Or use the data in the CloseChannelNotification object to do display your own)

        } else {
            // Handle any other (non-Close) notifications here
        }

    }

    // An OS notification was tapped when the app was not active, we can handle it here
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        let userInfo = response.notification.request.content.userInfo
        if let closeChannelNotification = CloseChannelNotification.from(userInfo: userInfo) {
            // This is a close notification, let's handle it

            if let channelId = closeChannelNotification.channelId {
                if closeChannelNotification.openInInfoView {
                    self.closeChannelController.openChannelInfoView(channelId: channelId, window: nil)
                } else {
                    self.closeChannelController.openChannelMessagesView(channelId: channelId, window: nil)
                }
            }

        } else {
            // Handle any other (none-Close) notifications here
        }

    }
}

