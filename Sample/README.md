# Mobile Close Channel SDK - Sample App

This sample app shows the different features of the [Mobile Close Channel SDK](../README.md).

Some of the features that are showcased:

* Registering a user on the Close platform
* Adding a channel
* Getting a list of channels and show them in a UITableView
* Opening the Messages view or the Info view of a channel
* Showing received push notifications from Close
* Handling tapping on push notifications by navigating to the Messages or Info view

## Documentation

Details can be found on the GitHub page of the [Mobile Close Channel SDK](../README.md) and in the [SDK Reference documentation](../doc/SDK%20Reference%20Documentation)

## License

You can use the source code in this example in your own projects according to the [Apache 2.0 license](LICENSE)

# Using the App

## Access to the binary
⛔️ The binary of the SDK framework is in a private repository: https://github.com/close-dev-team/mobile-close-channel-sdk-binary-ios. Please first contact [us](mailto:maurice@thecloseapp.com) to get access to this repository. Make sure you received and accepted the invite before you continue.

Then [use a Personal Access Token (PAT) on GitHub as explained here](docs/binary_access.md) to clone the repository of the SDK framework binary. Use this token later when asked for a username and password for access to private repository.

Start with cloning this repository:

```bash
git clone https://github.com/close-dev-team/mobile-close-channel-sdk-ios.git
cd mobile-close-channel-sdk-ios.git
```

## Building the App
* Then run Cocoapods:

```bash
pod install --repo-update
```

* Change the bundle id of the app before building it
* The app at default will communicate with a test environment. Please change the api_base_url as described [here](https://github.com/close-dev-team/mobile-close-channel-sdk-ios) into one you received from Close.

## Registering a user
The first time you start the app and open the Channels list, you'll see a *Could not retrieve list of channels / API call failed - User not valid* message.

This means that you first have to register a user.

Go to the *Options* tab and tap *Register user*

>This will do a [registerUser()](../doc/SDK%20Reference%20Documentation/classes/CloseChannelController.md) call with the values you provide. If you leave the values empty, they will be sent as a *nil* value. Any errors are shown in a popup.

## Adding a channel

When the user is registered, a channel can be added. Go to the *Options* tab and tap *Add channel*. Then type for example `DEMO` to add a channel.

💁‍♂️ Ask Close for other show codes.

>This will do an [addChannel()](../doc/SDK%20Reference%20Documentation/classes/CloseChannelController.md) call with the value you provide. Any errors are shown in a popup.

## Opening a channel

In the *Options* tab and tap *Open latest channel (messages)* or *Open latest channel (info)* to open a the latest added channel in either of the views.

>This will do a [openChannelMessagesView(channelId: nil) or openChannelInfoView(channelId: nil)](../doc/SDK%20Reference%20Documentation/classes/CloseChannelController.md) call. Any errors are shown in a popup.

In the *Channels* tab you'll find an overview of all channels. This show how you use the information in the Channel object to build up a UITableView.

>The channels are retrieved via an [getChannels()](../doc/SDK%20Reference%20Documentation/classes/CloseChannelController.md)

Tapping on it allows you to open it in one of the views.

>This will do a [openChannelMessagesView() or openChannelInfoView()](../doc/SDK%20Reference%20Documentation/classes/CloseChannelController.md) call, with the channel ID of that channel.

## Push notifications

The sample app show how to identify push notifications from Close and how to parse and use the information in it. It also implements opening a channel after tapping a push notification.

⚠️ Push notifications are not shown in the sample app when your are using the standard SDK test environment. Contact Close to setup a separate environment for testing push notifications.

Detailed information on push notifications can be found [here](../doc/push_notifications.md)
