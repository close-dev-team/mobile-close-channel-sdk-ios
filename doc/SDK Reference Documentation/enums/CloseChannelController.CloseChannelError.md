**ENUM**

# `CloseChannelController.CloseChannelError`

**Contents**

- [Cases](#cases)
  - `InternalSdkError`
  - `ApiCallFailedServerUnreachable`
  - `ApiCallFailedServerError`
  - `ApiCallFailedUserNotValid`
  - `CloseCodeDoesNotExist`
  - `CloseChannelAlreadyExists`
  - `ChannelIdNotFound`
  - `NoChannelAvailable`
- [Properties](#properties)
  - `code`
  - `message`
  - `rawString`

```swift
public enum CloseChannelError: UInt
```

## Cases
### `InternalSdkError`

```swift
case InternalSdkError = 25000
```

Some fatal internal error occurred, check console output for hints

### `ApiCallFailedServerUnreachable`

```swift
case ApiCallFailedServerUnreachable = 25101
```

The server could not be reached, most likely because internet is not available. Could be used to retry call after internet is restored.

### `ApiCallFailedServerError`

```swift
case ApiCallFailedServerError = 25102
```

The Close server reported an error or returned incorrect data

### `ApiCallFailedUserNotValid`

```swift
case ApiCallFailedUserNotValid = 25103
```

The user token is not valid or the user has not been registered yet

### `CloseCodeDoesNotExist`

```swift
case CloseCodeDoesNotExist = 25201
```

The Close code specified does not exist

### `CloseChannelAlreadyExists`

```swift
case CloseChannelAlreadyExists = 25202
```

There is already a channel created for this user with the provided Close code

### `ChannelIdNotFound`

```swift
case ChannelIdNotFound = 25301
```

The channel with the specified ID was not found

### `NoChannelAvailable`

```swift
case NoChannelAvailable = 25302
```

No channel was available, this can happen when calling a function without channel ID, and no channel yet exist for the user

## Properties
### `code`

```swift
public var code: UInt
```

Unique error code

### `message`

```swift
public var message: String
```

English error message

### `rawString`

```swift
public var rawString: String
```
