**ENUM**

# `CloseChannelController.CloseChannelError`

**Contents**

- [Cases](#cases)
  - `InternalSdkError`
  - `ApiCallFailedServerUnreachable`
  - `ApiCallFailedServerError`
  - `ApiCallFailedUserNotValid`
  - `ApiCallFailedAccessTokenNotValid`
  - `CloseCodeDoesNotExist`
  - `CloseChannelAlreadyExists`
  - `ChannelIdNotFound`
  - `NoChannelAvailable`
- [Properties](#properties)
  - `code`
  - `message`
  - `rawString`

## Cases
### `InternalSdkError`

Some fatal internal error occurred, check console output for hints

### `ApiCallFailedServerUnreachable`

The server could not be reached, most likely because internet is not available. Could be used to retry call after internet is restored.

### `ApiCallFailedServerError`

The Close server reported an error or returned incorrect data

### `ApiCallFailedUserNotValid`

The user token is not valid or the user has not been registered yet

### `ApiCallFailedAccessTokenNotValid`

API call failed - API Access token not valid

### `CloseCodeDoesNotExist`

The Close code specified does not exist

### `CloseChannelAlreadyExists`

There is already a channel created for this user with the provided Close code

### `ChannelIdNotFound`

The channel with the specified ID was not found

### `NoChannelAvailable`

No channel was available, this can happen when calling a function without channel ID, and no channel yet exist for the user

## Properties
### `code`

Unique error code

### `message`

English error message

### `rawString`
