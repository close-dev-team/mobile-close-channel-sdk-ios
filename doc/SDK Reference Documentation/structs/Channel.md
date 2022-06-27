**STRUCT**

# `Channel`

**Contents**

- [Properties](#properties)
  - `id`
  - `eventId`
  - `name`
  - `startDateTime`
  - `endDateTime`
  - `backgroundColor`
  - `backgroundImageUrl`
  - `profileImageUrl`
  - `unreadMessages`

```swift
public struct Channel
```

The Channel object contains all information of a certain channel

Use it to populate tableviews, show details of a channel or manage badges
to indicate unread messages.

## Properties
### `id`

```swift
public let id: String
```

The unique public ID of a channel. A channel is unique for each user.

A channel ID starts with `CLEC`

### `eventId`

```swift
public let eventId: String
```

The unique public ID of the channel's event

An 'Event' is is not unique for each user and is a template for creating a channel. You can see an 'event' as a class and a 'channel' as an instance of an event.

An event ID starts with `CLEV`

### `name`

```swift
public let name: String
```

The name of the channel

### `startDateTime`

```swift
public let startDateTime: Date
```

The start date and time for this event

### `endDateTime`

```swift
public let endDateTime: Date
```

The end date and time for this event

### `backgroundColor`

```swift
public let backgroundColor: UIColor
```

The background color for this event

### `backgroundImageUrl`

```swift
public let backgroundImageUrl: URL?
```

Url to the background image for this event

### `profileImageUrl`

```swift
public let profileImageUrl: URL?
```

Url to the profile image for this event

### `unreadMessages`

```swift
public let unreadMessages: UInt
```

The number of unread messages for this chat

This includes both the messages in the Messages and in the Info view
