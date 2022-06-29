# Problems and solutions

## Run-time errors

### Configuring the API base URL
When setting up the `CloseChannel-Info.plist` file, any errors will appear in the console logging.

#### "The API base URL is not set"

Set the API base URL as described in the [README](../README.md).

#### "Could not find key 'api_base_url' with a String value in CloseChannel-Info.plist"

Check if there is an `api_base_url` key with a `String` type in the `CloseChannel-Info.plist` file.

#### "Could not find dictionary as a root element in CloseChannel-Info.plist"

Check if the plist file is formatted correctly and starts with a root element that is of a `Dictionary` type

#### "Fatal Error: could not find CloseChannel-Info.plist"

Check if the `CloseChannel-Info.plist` file exists and has the exact same name. Note case sensitivity on case-sensitive file systems.

## Compile/link errors

### "Compiling for iOS xx.x, but module 'xxxxxx' has a minimum deployment target of iOS yy.y"

The SDK supports back to a minimum iOS version. The actual minimum supported iOS version can be found [here](../README.md). If your app is supporting an iOS versions before the minimum supported iOS version of the SDK, you'll receive the error above.

The solution is to increase the `iOS Deployment target` in the project setting of your app.

[Back to the main page](../README.md)

### "dyld: Library not loaded: @rpath/CloseChannel.framework/CloseChannel"

If the CloseChannel framework could not be loaded, please check to see if it has added correctly, and the *Embed* setting is set to *Embed & Sign*. With *Embed Without Signing* it would work when running in Debug or in the Simulator, but not when trying to create an archive.

  ![](https://github.com/close-dev-team/mobile-close-channel-sdk-ios/raw/main/doc/images/screenshot_add_framework.png)
