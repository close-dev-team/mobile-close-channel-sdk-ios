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

The Channel object contains all information of a certain channel

Use it to populate views, show details and images of a channel and manage badges
to indicate unread messages.

## Properties
### `id`

The unique public ID of a channel. A channel is unique for each user.

A channel ID starts with `CLEC`

### `eventId`

The unique public ID of the channel's event

An 'Event' is is not unique for each user and is a template for creating a channel. You can see an 'event' as a class and a 'channel' as an instance of an event.

An event ID starts with `CLEV`

### `name`

The name of the channel

### `startDateTime`

The start date and time for this event

### `endDateTime`

The end date and time for this event

### `backgroundColor`

The background color for this event

### `backgroundImageUrl`

Url to the background image for this event

### `profileImageUrl`

Url to the profile image for this event

### `unreadMessages`

The number of unread messages for this chat. This includes both the messages in the Messages and in the Info view
