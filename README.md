# Mobile Close Channel SDK (for iOS)

The Mobile Close Channel SDK allows you to integrate the Close communication platform in your own iOS app.

## No buckles needed

We are developers ourselves and we know how frustrating it can be to integrate an SDK. But not this time: we will do our best to make it a fun exercise instead! Pinky promise, this won't be an emotional roller coaster: buckles are not needed!

So, take a coffee ☕️, tea 🫖, or havermelk 🥛 and take my hand to guide you through this in a few easy steps.
If you still run into problems don't hesitate to contact us via https://sdk.thecloseapp.com

## Pre-requisites and notes

### Build environment
To make an easy start, be sure you have this Xcode versions:

* Xcode 14.0 or 14.1

Newer versions could work / should work, but we have verified it to work with the above tool versions.

These older versions of Xcode are verified to work with SDK version 1.2.4:

* Xcode 13.2.1
* Xcode 13.4.2

### What you'll need from us to start integration

* To get access to our private repository with our SDK framework, you'll need:
    * a GitHub account
    * a GitHub personal access token, how to create one is explained [here](doc/binary_access.md)
* To get access to the Close platform you'll need:
    * A _CloseChannel-Info.plist_ file
      * That contains an API base URL and API access token (values to access our sandbox environment can be found below)
    * A Close Code of the flow that needs to be presented in one of the channels (or use `SDKDEMO` to start testing)

### Supported iOS versions and architectures

⚠️ The SDK supports iOS version 12.0 and higher, be sure the `iOS Deployment target` in the project settings of your app is set to 12.0 or higher.
Both Arm and x86 processor architectures are supported, thus the SDK will also work in the simulator.

> ⚠️ iPad targets are not fully supported, there could be cosmetic issues
  ⚠️ SwiftUI is not specifically supported

### Localisation

The SDK supports `en_GB`, `en_US`, `nl` and `de` localisations. Please note that to use these localisations your app also must support these. The default localisation is `en_GB`.

### Orientation

Please note that the SDK only support portrait mode for showing the chat messages and info messages views. Take special care for not allowing the screen to rotate in landscape.

# Quick start

## Stop ⏹! Start ▶️ with a sample

It is **strongly recommended** to first start with the [Mobile Close Channel SDK Sample](./Sample/) which showcases how to use the SDK and the different features it provides. It talks to a test environment that can be used to test with.

When you've done that you can come back to this page to continue the wonderful journey of integrating Close in your own app.

## Step 1: Adding the SDK

To add the SDK to your project follow the steps in this section.

### Using Cocoapods
#### Cloning the SDK framework binary
---

⛔️ IMPORTANT: The SDK framework binary is in a private repository. [Read this to see how to get access](doc/binary_access.md).

---

#### Adding the Close framework
When you have arranged that, then add Close to your Podfile.

* In your Podfile add the Close CocoaPods specs repository:

```
source 'https://github.com/close-dev-team/close-cocoapods-specs.git'
```
* Then add the Close Channel framework:

```
pod 'CloseChannel'
```

Also add to the end of your Podfile:

```
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
        end
    end
end
```

This is needed, otherwise you will get 'dyld: Symbol not found' errors during compilation. See https://github.com/CocoaPods/CocoaPods/issues/9775 for more info.


* Next, run:

`pod install --repo-update`

* You are asked for your E-mail address and password. Make sure that you **enter the personal access token you created before as your password**. If you did not create it yet, check [this](doc/binary_access.md)
* When you have done all the above you can start using the CloseChannel framework in your code by simply importing it:

```swift
import CloseChannel
```

<details>
<summary>Example of a minimal `Podfile`</summary>

```
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/close-dev-team/close-cocoapods-specs.git'
platform :ios, '12.0'

target 'Close Channel Sample' do
  use_frameworks!

  pod 'CloseChannel'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'

            if target.name == 'SwiftSocket'
              config.build_settings['SWIFT_VERSION'] = '5.0'
            end
        end
    end
end
```

</details>

### Alternative: adding the framework manually
You can also add the framework manually. Make sure you first clone the aforementioned repository. Then copy the framework into your project.

<details>
<summary>Show me how</summary>

* Copy the `Close Channel.xcframework` folder into the folder of your project
* In the project settings of the target
  * On the *General* tab under *Framework, Libraries and Embedded content* tap the *plus (+)*
  * Tap *Add other* and browse to the framework and add it
  * Be sure that *Embed & sign* is selected

  ![](https://github.com/close-dev-team/mobile-close-channel-sdk-ios/raw/main/doc/images/screenshot_add_framework.png)

  </details>

## Step 2: Using the SDK

The CloseChannelController instance is the one you're going to talk to. Let's first create it.

```swift
  import CloseChannel

  class AppDelegate: UIResponder, UIApplicationDelegate {
    let closeChannelController = CloseChannelController.sharedInstance
  }
```

>Note: or simplicity sake, in the examples we use create the CloseChannelController in the AppDelegate. This is a bad practice and we advise you to create it somewhere else.

As it is a singleton instance, you can create and use it in any of your classes.

### Configuring the Close endpoint URL

When you run this, in the console you will see the message: `The API base URL is not set`. That's because the SDK does not know to which Close endpoint it should to talk to. This URL needs to be configured first.

You can configure this by following these steps:

* Add a plist file named `CloseChannel-Info.plist` to your project, don't forget to add it to the correct target(s)
* Add a string property named `api_base_url` with the URL as the value.
* Add a string property named `api_access_token` with the API access token (see below) as the value.

⚠️ For testing purposes you can use the url `https://api.sdk-sandbox.closetest.nl:16443/`, and the api_access_token `sdk-sandbox-access-token` but this should be replaced later with the URL that Close provides to your company.

<details>
  <summary>Example `CloseChannel-Info.plist` file</summary>

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>api_base_url</key>
	<string>https://api.sdk-sandbox.closetest.nl:16443/</string>
	<key>api_access_token</key>
	<string>sdk-sandbox-access-token</string>  
</dict>
</plist>
```

  ![](https://github.com/close-dev-team/mobile-close-channel-sdk-ios/raw/main/doc/images/screenshot_api_base_url.png)

  A sample file can be found [here](https://github.com/close-dev-team/mobile-close-channel-sdk-ios/raw/main/doc/samples/CloseChannel-Info.plist).
</details>


## Step 3: Registering a user

When the SDK is correctly set up we can continue connecting to the Close platform. This starts with registering a user on our platform.

```swift
import UIKit
import CloseChannel

class YourUserProvider {
    static func appUser() -> AppUser {
        return AppUser()
    }
}
struct AppUser {
    let id = "a_unique_id"
    let name = "mieke"
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  let closeChannelController = CloseChannelController.sharedInstance

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let appUser = YourUserProvider.appUser()
    closeChannelController.registerUser(uniqueId: appUser.id,
                                        nickname: appUser.name) { closeUserId in
        // The returned closeUserId is a unique identifier that Close uses to identify users. You can store
        // it for later use.
    } failure: { error in
        print("Failed to register user: \(error.code) \(error.message)")
    }
    return true
  }
}
```

A `uniqueId` is the id for a user in Close. Please make sure this is something a user cannot change him/herself, because then it would not be possible to link to the same data. So don't use a phone number or E-mail address. Instead, for example, use an UUID. If the value is null a uniqueId will be generated

The `nickname` is the nickname, first name or full name of the user. It is optional so does not have to be specified.

When registerUser is called multiple times, it will return the already existing user. It is not possible to change the uniqueId or to change the nickname with the registerUser call.

Please make sure to read the [SDK reference documentation](./doc/SDK%20Reference%20Documentation/) for more information

The `YourUserProvider` class in this code snippet provides a way to get user data. Replace this with your own implementation. The most important thing here is that you retrieve something that is unique to the user.

>⚠️ `uniqueId` is optional. If the value is nil a unique ID will be generated.
  Please make sure to read the [SDK reference documentation](./doc/SDK%20Reference%20Documentation/) for all details.

## Step 4: Adding a channel

After the user is registered you only should add a channel.
Please contact Close for the correct Close code for your app. For now you can use `SDKDEMO`

```swift
closeChannelController.addChannel(closeCode: "SDKDEMO") { channel in
    print("Channel succesfully added")

} failure: { error in
    print("Could not add channel: \(error.code) \(error.message)")
}
```

>⚠️ Note that you should only add a channel once. When you try to add another channel with the same Close code, you'll receive an error. You can use the `getCloseChannels` function to check if a channel is already available, before adding it. See the section **Tying it all together** below for an example.

## Step 5: Showing a channel

To show a channel, you can simple call the function below to open the last added channel. Be sure to do this on the main thread.

```swift
DispatchQueue.main.async {
    closeChannelController.openChannelMessagesView()
}
```

There are 2 ways of showing the channel:

   * **Channel messages view**. This shows messages in a chat-like way with text balloons, ordered by date/time of sending
   * **Channel info view**. This shows informational messages, tickets and bought products, ordered by pre defined order

<details>
  <summary>Showing the channel info view<</summary>

  ```swift
  DispatchQueue.main.async {
      closeChannelController.openChannelInfoView()
  }
  ```

</details>

<details>
  <summary>Opening a specific channel</summary>

Alternatively you can retrieve a list of channels and use the channel ID to open a specific channels

```swift
closeChannelController.getChannels { channels in
    if channels.count > 0 {
        let channel = channels[0]
        DispatchQueue.main.async {
            self.closeChannelController.openChannelMessagesView(channelId: channel.id)
        }
    }
} failure: { error in
    print("Failed to get channels: \(error.code) \(error.message)")
}
```
</details>

### Presenting a channel on an existing viewcontroller

So far you have learned how you show a channel in the easiest way by opening it fullscreen. If you want to have more control, like adding your own navigation bar or make the channel part of a tab bar, you should use `getChannelMessagesViewController` (or the alternative `getChannelInfoViewController`):

```swift
    closeChannelController.getChannelMessagesViewController(success: { channelMessagesViewController in
        // Set the modalPresentationStyle property
        // and present the viewcontroller
    })
```

>Please note that not all modal presentation styles are currently supported. Check the changelog for known issues.

> Also note that you should always reserve a large part (80% or more) of your screen to display the close channel correctly

In this section some examples, make sure you do the calls on the main thread:

<details>
  <summary>Show without a navigation bar</summary>

With `openChannelMessagesView` a navigation bar is shown in the colors defined in the Close builder. If you want to show the channel without a navigationbar you could do this:

```swift
    closeChannelController.getChannelMessagesViewController(success: { channelMessagesViewController in
        channelMessagesViewController.modalPresentationStyle = .fullScreen
        yourViewController.present(channelMessagesViewController, animated: true)
    })
```
</details>

<details>
  <summary>Show with a custom navigation bar</summary>

If you want to have your own navigation bar, you can do something like:

```swift
    closeChannelController.getChannelMessagesViewController(success: { channelMessagesViewController in
        let navigationController  = UINavigationController(rootViewController: channelMessagesViewController)
        channelMessagesViewController.title = "Messages"
        
        // (Do any navigation bar appearance customizations here)

        channelMessagesViewController.modalPresentationStyle = .fullScreen
        yourViewController.present(channelMessagesViewController, animated: true)
    })
```
</details>

<details>
  <summary>Show in a tab</summary>

If you want to show the channel as part of a tab, you could do this:

```swift
    closeChannelController.getChannelMessagesViewController(success: { channelMessagesViewController in
        yourTabBarController.viewControllers = [channelMessagesViewController]
    })
```
</details>

<details>
  <summary>Show in a tab with a navigationbar</summary>

To use this combination, you can simply add a navigation controller in between. Then instead of adding the channel viewcontroller, add the navigation controller to the tabbar:

```swift
    closeChannelController.getChannelMessagesViewController(success: { channelMessagesViewController in
        let navigationController  = UINavigationController(rootViewController: channelMessagesViewController)
        channelMessagesViewController.title = "Messages"
        yourTabBarController.viewControllers = [navigationController]
    })
```
</details>

# Tying it all together

As closures are used to return wether a call succeeded or failed, it is easy to tie everything together:

* We register a user
* When that succeeds, we check if there are channels available
  * If so, we open the last added channel
  * If not, we create a channel and open that one

```swift
import UIKit
import CloseChannel

class YourUserProvider {
    static func appUser() -> AppUser {
        return AppUser()
    }
}
struct AppUser {
    let id = "a_unique_id"
    let name = "mieke"
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let closeChannelController = CloseChannelController.sharedInstance

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appUser = YourUserProvider.appUser()
        closeChannelController.registerUser(uniqueId: appUser.id,
                                            nickname: appUser.name) { closeUserId in
            // The returned closeUserId is a unique identifier that Close uses to identify users. You can store
            // it for later use.
        } failure: { error in
            print("Failed to register user: \(error.code) \(error.message)")
        }

        showChannel()
        return true
    }

    func showChannel() {
        let appUser = YourUserProvider.appUser()
        closeChannelController.registerUser(uniqueId: appUser.id,
                                            nickname: appUser.name) { closeUserId in


            self.closeChannelController.getChannels { channels in
                if channels.count == 0 {
                    self.closeChannelController.addChannel(closeCode: "SDKDEMO") { channel in
                        DispatchQueue.main.async {
                            self.closeChannelController.openChannelMessagesView()
                        }

                    } failure: { error in
                        print("Could not add channel: \(error.code) \(error.message)")
                    }

                } else {
                    DispatchQueue.main.async {
                        self.closeChannelController.openChannelMessagesView()
                    }
                }

            } failure: { error in
                print("Failed to get channels: \(error.code) \(error.message)")
            }


        } failure: { error in
            print("Failed to register user: \(error.code) \(error.message)")
        }
    }
}
```

# Congratulations!

Your app is now integrated with the Close platform! To improve and make it ready for production please check out the sections below.

## Use the correct Close endpoint URL, API access token and Close code
Change the `api_base_url` and `api_access_token` to the correct ones you received from Close. Also make sure
to use the right Close code. It can happen that the one for a Testing or Staging environment
differs from the one on the Production environment.

## Add permission strings
Before being able to upload the app to Apple, [add permission strings](./doc/permissions.md) for any of the permissions not already supported by your app.

# Where to continue from here?

## SDK Reference Documentation

The code samples in the sections above have been simplified by not showing all parameters. Make sure you read the [SDK reference documentation](./doc/SDK%20Reference%20Documentation/) for all details. Also if you want more control over the views, check the reference documentation as there are interface methods to suit all your needs.

Start [here](./doc/) for an overview of the documentation.

## Error handling

Additionally, in the code samples above, error handling has been greatly simplified. You should improve on error handling and add retries, [which is explained in detail here](./doc/error_handling.md).

## Push notifications

Messages are meaning nothing if your users don't read them. Be sure you connect
the Close push notifications. It's not hard, we do most of the work for you. [Continue reading here](./doc/push_notifications.md).

## List of channels

If you want to integrate with multiple channels and want to implement an overview of channels, [be sure to checkout this document](./doc/list_of_channels.md)

## Create your own flows

With the Close Builder you can create your own flows to send to your users. Use the account provided by Close to login and start building!

![](https://github.com/close-dev-team/mobile-close-channel-sdk-ios/raw/main/doc/images/builder.png)


## Problems and solutions

When running into problems, please check out [this document](./doc/problems_and_solutions.md) first.

* Report any issues found in the documentation or sample code [here](https://github.com/close-dev-team/mobile-close-channel-sdk-ios/issues)
* Report any issues found in the SDK [here](https://github.com/close-dev-team/mobile-close-channel-sdk-binary-ios/issues)

Note that references to CL-#### in commit messages refer to issues in our private issue tracker.
