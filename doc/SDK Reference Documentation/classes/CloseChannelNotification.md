**CLASS**

# `CloseChannelNotification`

**Contents**

- [Properties](#properties)
  - `message`
  - `channelId`
  - `openInInfoView`
- [Methods](#methods)
  - `from(userInfo:)`

```swift
public class CloseChannelNotification
```

Convenience class to help with handling Close notifications

Create an instance with the userInfo from a push notification and use
the data fields to show custom in-app push notifications and to handle
the actions when the notification is tapped.

## Properties
### `message`

```swift
public var message: String?
```

The push notification message

The message is in the lanuage of the user, but only if that language
is supported in the channel

### `channelId`

```swift
public var channelId: String?
```

The channel ID of the channel the message is related to

### `openInInfoView`

```swift
public var openInInfoView: Bool
```

When this boolean is true it means the message is related to the Info vIEW
view of the channel, otherwise if is related to the Messages View of the
channel

## Methods
### `from(userInfo:)`

```swift
public static func from(userInfo: [AnyHashable: Any]) -> CloseChannelNotification?
```

Creates a notification object using the userInfo contained in a push notification

Returns nil if it's not a Close push notification
