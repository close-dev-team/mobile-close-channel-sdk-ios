# Error handling

Functions in the SDK that can fail have two closures.

* success
* failure

These are respectively called when then call succeeded or failed. In case of failure a [CloseChannelError](./doc/SDK%20Reference%20Documentation/enums/CloseChannelController.CloseChannelError.md) object is passed which contains details of the error.

## Retrying calls
It is good practice to retry the calls in case of ApiCallFailed-errors like `ApiCallFailedServerUnreachable` or `ApiCallFailedServerError` error.

## User not valid
If you receive an `ApiCallFailedUserNotValid` it means the user's token is not valid anymore. **The token never expires but becomes invalid when the unique id is being re-used**. This can happen when the user reinstalls the app or installs the app on another device.

To renew the token, re-register the user again.

## Internal SDK Error
If you receive an internal SDK error it can mean there is something wrong in scenario you are trying to implement , or that we made a booboo. Contact us for help.

## Other errors

All errors that can be reported are explained [here](https://github.com/close-dev-team/mobile-close-channel-sdk-ios/blob/main/doc/SDK%20Reference%20Documentation/enums/CloseChannelController.CloseChannelError.md)
