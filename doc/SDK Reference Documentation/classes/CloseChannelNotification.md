**CLASS**

# `CloseChannelNotification`

**Contents**

- [Properties](#properties)
  - `message`
  - `channelId`
  - `openInInfoView`
- [Methods](#methods)
  - `from(userInfo:)`

Convenience class to help with handling Close notifications

Create an instance with the userInfo from a push notification and use
the data fields to show custom in-app push notifications and to handle
the actions when the notification is tapped.

## Properties
### `message`

The push notification message

The message is in the lanuage of the user, but only if that language
is supported in the channel

### `channelId`

The channel ID of the channel the message is related to

### `openInInfoView`

When this boolean is true it means the message is related to the Info
view of the channel, otherwise if is related to the Messages View of the
channel

## Methods
### `from(userInfo:)`

Creates a notification object using the userInfo contained in a push notification

Returns nil if it's not a Close push notification
