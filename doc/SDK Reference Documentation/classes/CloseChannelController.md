**CLASS**

# `CloseChannelController`

**Contents**

- [Properties](#properties)
  - `initialized`
  - `sharedInstance`
  - `version`
- [Methods](#methods)
  - `deinit`
  - `registerUser(uniqueId:nickname:success:failure:)`
  - `addChannel(closeCode:success:failure:)`
  - `getChannels(success:failure:)`
  - `getChannelMessagesViewController(channelId:parent:navigationType:success:failure:)`
  - `getChannelInfoViewController(channelId:parent:navigationType:success:failure:)`
  - `openChannelMessagesView(channelId:window:success:failure:)`
  - `openChannelInfoView(channelId:window:success:failure:)`
  - `storeChannelProperties(properties:channelId:success:failure:)`
  - `removeChannel(channelId:success:failure:)`
  - `registerPushInfo(token:permissionGranted:success:failure:)`

```swift
public class CloseChannelController
```

---
# Close Channel Controllor that is used to access the SDK

## Properties
### `initialized`

```swift
public static var initialized = false
```

Returns a singleton instance of the controller

- Returns: the instance to `CloseChannelController`

Usage example:
    `let closeChannelController = CloseChannelController.sharedInstance`

### `sharedInstance`

```swift
public static let sharedInstance: CloseChannelController =  CloseChannelController()
```

### `version`

```swift
public var version: String
```

Returns the SDK version in the form 1.2.3 where:

- 1 is the major version
- 2 is the minor version
- 3 is the patch level

## Methods
### `deinit`

```swift
deinit
```

### `registerUser(uniqueId:nickname:success:failure:)`

```swift
public func registerUser(uniqueId: String?,
                         nickname: String?,
                         success: @escaping (_ closeUserId: String) -> Void,
                         failure: ((_ error: CloseChannelError) -> Void)?)
```

Registers a user at Close. If it does not exist yet it will create one, otherwise it returns the existing one.

Note: If this call is done for subsequent times, it keeps returning the same user, regardless of the provided uniqueId. Also, the nickname will not be updated

In case of an error (e.e. server unreachable), make sure you retry until a user is successfully registered.

- parameters:
  - `uniqueId`: A unique id for a user. Please make sure this is something a user cannot change him/herself, because then it would not be possible to link to the same data. So don't use a phone number or E-mail address. Instead, for example, use an UUID. If the value is nil a uniqueId will be generated
  - `nickname`: Visible user name that can be used to personalise messages
  - `success`: Called when successfully completed
    - `closeUserId`:  The Close user ID of the user
  - `failure`: Called in case of an error
    - `error`: The error details

### `addChannel(closeCode:success:failure:)`

```swift
public func addChannel(closeCode: String,
                       success: @escaping (_ channnel: Channel) -> Void,
                       failure: ((_ error: CloseChannelError) -> Void)?)
```

Adds a new channel to the user

- parameters:
  - `closeCode`: The close code of the channel
  - `success`: Called when successfully completed
    - `channel`: The `Channel` that was added
  - `failure`: Called in case of an error
    - `error`: The error details

⚠️ Each unique Close code can be used only once to create a channel
If you try to add the same Close code twice, you will get an `CloseChannelAlreadyExists` error

### `getChannels(success:failure:)`

```swift
public func getChannels( success: @escaping (_ channels: [Channel]) -> Void,
                         failure: ((_ error: CloseChannelError) -> Void)?)
```

Get a list of available channels of the user

- parameters:
  - `success`: Called when successfully completed
    - `channels`: List of `Channel` objects
  - `failure`: Called in case of an error
    - `error`: The error details

### `getChannelMessagesViewController(channelId:parent:navigationType:success:failure:)`

```swift
public func getChannelMessagesViewController(channelId: String? = nil,
                                             parent: UINavigationController? = nil,
                                             navigationType: MessagesViewNavigationType = .builtInWithoutBackButton,
                                             success: @escaping ((_ channelMessagesViewController: ChannelViewController & ChannelMessageViewContainer) -> Void),
                                             failure: ((_ error: CloseChannelError) -> Void)? = nil)
```

Return the chat messages view controller for a channel
Be sure to call this function on the main thread!

- parameters:
  - `channelId`: The channel identifier of the channel to show. If nil or not supplied the most recently created channel will be used. If the channelId does not exist it will return an error (see below) and write a warning in the console.
  - `parent`: The parent view controller to present the channel in. Currently only a UINavigationController If not supplied a UINavigationController will be created.
  - `navigationBarType`: Wether or not to show a navigationbar or provide a custom one, see the enum values for an explantation
  - `success`: Called when the view will be presented
    -  `channelMessagesViewController`:  The chat messages view controller
  - `failure`: Called when the view failed being presented.
    - `error`:  The error details

## Possible errors:
- `CloseChannelError.ChannelIdNotFound` : When the specified channel could no be found
- `CloseChannelError.NoChannelAvailable` : No channel could be found. This could happen when you did not specifiy a channel id to open the most recently created one
- `CloseChannelError.InternalSdkError` : A fatal error occurred

⚠️  Be sure the view is dismissed and removed from memory before another Messages or Info view is shown. Having multiple simultaneously opened is not supported. Symptoms could include: some chat balloons not appearing, in-chat buttons not executing actions or the chat not dismissable.

### `getChannelInfoViewController(channelId:parent:navigationType:success:failure:)`

```swift
public func getChannelInfoViewController(channelId: String? = nil,
                                         parent: UINavigationController? = nil,
                                         navigationType: InfoViewNavigationType = .none,
                                         success: @escaping ((_ channelMessagesViewController: ChannelViewController) -> Void),
                                         failure: ((_ error: CloseChannelError) -> Void)? = nil)
```

Return the info view controller for a channel
Be sure to call this function on the main thread!

- parameters:
  - `channelId`: The channel identifier of the channel to show. If nil or not supplied the most recently created channel will be used. If the channelId does not exist it will return an error (see below) and write a warning in the console.
  - `parent`: The parent view controller to present the channel in. Currently only a UINavigationController If not supplied a UINavigationController will be created.
  - `navigationType`: Wether or not to show a navigationbar or provide a custom one, see the enum values for an explantation
  - `success`: Called when the view will be presented
    -  `channelMessagesViewController`:  The info view controller
  - `failure`: Called when the view failed being presented.
    - `error`:  The error details

## Possible errors:
- `CloseChannelError.ChannelIdNotFound` : When the specified channel could no be found
- `CloseChannelError.NoChannelAvailable` : No channel could be found. This could happen when you did not specifiy a channel id to open the most recently created one
- `CloseChannelError.InternalSdkError` : A fatal error occurred

⚠️  Be sure the view is dismissed and removed from memory before another Messages or Info view is shown. Having multiple simultaneously opened is not supported. Symptoms could include: some chat balloons not appearing, in-chat buttons not executing actions or the chat not dismissable.

### `openChannelMessagesView(channelId:window:success:failure:)`

```swift
public func openChannelMessagesView(channelId: String? = nil,
                                    window: UIWindow? = nil,
                                    success: (() -> Void)? = nil,
                                    failure: ((_ error: CloseChannelError) -> Void)? = nil)
```

Open a fullscreen view of a channel with the chat messages displayed
Be sure to call this function on the main thread!

- parameters:
  - `channelId`: The channel identifier of the channel to show. If nil or not supplied the most recently created channel will be used. If the channelId does not exist it will return an error (see below) and write a warning in the console.
  - `window`: The window to present the channel on. If not supplied the app window will be used. It is strongly advised to supply the window if your app supports external screens
  - `success`: Called when the view will be presented
  - `failure`: Called when the view failed being presented.
    - `error`:  The error details

## Possible errors:
- `CloseChannelError.ChannelIdNotFound` : When the specified channel could no be found
- `CloseChannelError.NoChannelAvailable` : No channel could be found. This could happen when you did not specifiy a channel id to open the most recently created one
- `CloseChannelError.InternalSdkError` : A fatal error occurred

⚠️ Be sure the view is dismissed and removed from memory before another Messages or Info view is shown. Having multiple simultaneously opened is not supported. Symptoms could include: some chat balloons not appearing, in-chat buttons not executing actions or the chat not dismissable.

### `openChannelInfoView(channelId:window:success:failure:)`

```swift
public func openChannelInfoView(channelId: String? = nil,
                                window: UIWindow? = nil,
                                success: (() -> Void)? = nil,
                                failure: ((_ error: CloseChannelError) -> Void)? = nil)
```

Open a fullscreen view of a channel with the info messages displayed
Be sure to call this function on the main thread!

- parameters:
  - `channelId`: The channel identifier of the channel to show. If nil or not supplied the most recently created channel will be used. If the channelId does not exist it will return an error (see below) and write a warning in the console
  - `window`: The window to present the channel on. If not supplied the app window will be used. It is strongly advised to supply the window if your app supports external screens
  - `success`: Called when the view will be presented
  - `failure`:  Called when the view failed being presented.
    - `error`: The error details

## Possible errors:
- `CloseChannelError.ChannelIdNotFound` : When the specified channel could no be found
- `CloseChannelError.NoChannelAvailable` : No channel could be found. This could happen when you did not specifiy a channel id to open the most recently created one
- `CloseChannelError.InternalSdkError` : A fatal error occurred

⚠️ Be sure the view is dismissed and removed from memory before another Messages or Info view is shown. Having multiple simultaneously opened is not supported. Symptoms could include: some chat balloons not appearing, in-chat buttons not executing actions or the chat not dismissable.

### `storeChannelProperties(properties:channelId:success:failure:)`

```swift
public func storeChannelProperties(properties: [String: String],
                                   channelId: String? = nil,
                                   success: (() -> Void)? = nil,
                                   failure: ((_ error: CloseChannelError) -> Void)? = nil)
```

Store properties to a channel
- parameters:
  - `properties`:  A map with key and values that you want to store. If the key exists, the data will be updated. If the key is new, a new record will be inserted.
  - `channelId`:  The channel identifier of the channel where properties should be stored. If nil or not supplied the most recently created channel will be used. If the channelId does not exist it will return an error (see below) and write a warning in the console
  - `success`:  Called when properties are sucessfully stored.
  - `failure`:  Called when the store properties failed.
    - `error`: The error details

### `removeChannel(channelId:success:failure:)`

```swift
public func removeChannel(channelId: String? = nil,
                          success: (() -> Void)? = nil,
                          failure: ((_ error: CloseChannelError) -> Void)? = nil)
```

Remove a channel
- parameters:
  - `channelId`:  The channel identifier. If nil or not supplied the most recently created channel will be used. If the channelId does not exist it will return an error (see below) and write a warning in the console
  - `success`:  Called when the channel is sucessfully removed.
  - `failure`:  Called when the channel removment is failed.
    - `error`: The error details

### `registerPushInfo(token:permissionGranted:success:failure:)`

```swift
public func registerPushInfo(token: String?,
                             permissionGranted: Bool,
                             success: @escaping (_ isPushEnabled: Bool) -> Void,
                             failure: ((_ error: CloseChannelError) -> Void)?)
```

Registers all needed data for receiving push notifications

- parameters:
  - `token`: The device token as a hexadecimal string, nil to unregister.
           To convert a device token to a hexadecimal string, use:

           `let pushToken = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})`

  - `permissionGranted`: Describes if the user has allowed receiving push notifications.
  Usually the result of a call to:

  ```
  UNUserNotificationCenter.current().requestAuthorization
  ````

  - `success`: Called when successfully completed
    - `isPushEnabled`: true when push notifications could be sent,
                      false when push notification could not be sent (no token or no permissions)
  - `failure`: Called in case of an error
    - `error`: The error details

## Push notification payload

The push notification that is sent has the following information in the
payload:

- `origin`: This value will always be "close". You can use this to distinguish
the push notifications from other sources
- `message`: the message to show
- `channelId`: the channel id the message is sent in
- `infoSpace`: true if the message is visible in the channel's info view, false if the message is visible in the channel's messages view
- `uuid`: unique identifier of the notification
- `url`: reserved for future use
- `chatId`: reserved or obsolete, do not use
- `userId`: reserved or obsolete, do not use

All these entries are strings.

NOTE: It is recommended to use the helper class CloseChannelNotification to
create a notification object from the userinfo. For example:

```
if let closeNotification = CloseChannelNotification.from(userInfo: userInfo) {
}
```
