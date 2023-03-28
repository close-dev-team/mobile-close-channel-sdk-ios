# Push notifications

## Preparations

Besides the bundle ID of your app we need your *key* for *Apple Push Notifications service (APNs)*. You can create this in the Apple Developer portal in the section *Certificates, Identifiers & Profiles*.

Please make sure you share these values with us:

  - Private key (p8 file contents or a base64 string of it)
  - Key ID
  - Team ID

Contact us via https://sdk.thecloseapp.com for more information.

## Registering

To receive push notifications from Close you need to send the device id (aka device token aka push tokens). This can be done through a call to:

```swift
registerPushInfo(token:permissionGranted:success:failure:)registerPushInfo(token:permissionGranted:success:failure:)
```

It's a best practice to do this in the AppDelegate every time the app starts.

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		registerForPushNotifications()
		return true
}
```

Then we request permission for push notifications.

```swift
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
```

When we have permission, register the device aka push token.

```swift
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
```

## Showing Close push notifications

When the app is not active, the OS handles the push notifications. When the app is active you need to do that yourself. You can use the ```CloseChannelNotification``` convenience class to easily distinguish between Close notifications and your own.

```swift
func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        let userInfo = notification.request.content.userInfo
        if let closeChannelNotification = CloseChannelNotification.from(userInfo: userInfo) {
            print("Notification received: \(closeChannelNotification.message ?? "")")

            // Let the OS handle the notification...
            completionHandler([.alert, .badge, .sound])

            // (Or use the data in the CloseChannelNotification object to do display your own)

        } else {
            // Handle any other (non-Close) notifications here
        }

    }
```

#### Best practices
When a messages view or info view is opened it is a good practice not to show a toaster with the message for that particular view. The user already is in that view and the incoming message will be shown anyway. You can use the `openInInfoView` boolean in `CloseChannelNotification` to see for what view the message is meant.

## Handling taps

To handle notifications and open the Messages or Info view you can also can use the ```CloseChannelNotification``` convenience class. Not only to easily distinguish between Close notifications and your own, but also to check if the push notification is meant for either the Messages or Info view by checking the `openInInfoView` boolean.

```swift
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
```

## Not using the CloseChannelNotification convenience class

If you prefer not to use the CloseChannelNotification class and parse the push notification message yourself, check out [the 'Push notification payload` section in the reference documentation](./SDK%20Reference%20Documentation/classes/CloseChannelController.md)

# Testing push notifications with Knuff

Without the push notifications certificate installed in the Close platform environment, it is still possible to test sending push notifications.

Use a tool like (Knuff)[https://github.com/KnuffApp/Knuff] to do that.

Use a payload like below:

```yml
{
  "aps":{
    "alert":"This is a title",
    "sound":"default",
    "badge":1,
  },
  "userId": 0,
  "chatId": 00000001,
    "infoSpace": "true",
  "message": "This is a message",
  "url": "",
  "origin": "close",
  "channelId": "CLECXXXXXXXXXXXXXXXXXXXXXXXXXX"
}
```

The keys are explained in [the 'Push notification payload` section in the reference documentation](./SDK%20Reference%20Documentation/classes/CloseChannelController.md)

Tap on a channel in the sample app and select *Show channel ID* to find the `channelId`. When it's specified, tapping the push notification should open the Messages or Info view, depending on the value of `infoSpace`
