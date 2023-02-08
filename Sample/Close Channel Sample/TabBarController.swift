//
//  TabBarController.swift
//  Close Channel Sample
//
//  Created by Close BV de Bijl on 5/25/22.
//

import UIKit
import CloseChannel

class TabBarController: UITabBarController {

    let closeChannelController = CloseChannelController.sharedInstance

    var channelsTableViewController: ChannelsTableViewController?
    var optionsViewController: OptionsViewController?

    override func viewDidLoad() {
        for viewController in ((viewControllers ?? []).compactMap { ($0 as? UINavigationController)?.topViewController }) {
            switch viewController {
            case is ChannelsTableViewController:
                channelsTableViewController = viewController as? ChannelsTableViewController
            case is OptionsViewController:
                optionsViewController = viewController as? OptionsViewController
            default:
                break
            }
        }

        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            tabBarAppearance.backgroundColor = UIColor.white
            UITabBar.appearance().standardAppearance = tabBarAppearance

            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }

            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(named: "AccentColor")
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }

        optionsViewController?.registerUserTap = {
            func registerUser(uniqueId: String?, nickname: String?) {
                self.closeChannelController.registerUser(uniqueId: uniqueId,
                                                         nickname: nickname) { closeUserId in
                    DispatchQueue.main.async {
                        let alert = UIAlertController(
                            title: "User with id \(closeUserId) registered",
                            message: nil,
                            preferredStyle: UIAlertController.Style.alert)

                        alert.addAction(UIAlertAction(title: "Ok",
                                                      style: .cancel) {  _ in
                            alert.dismiss(animated: true, completion: nil)
                        })

                        UIApplication.mainWindow?.rootViewController?.present(alert, animated: true,
                                                                 completion: nil)
                    }

                } failure: { error in
                    DispatchQueue.main.async {
                        let alert = UIAlertController(
                            title: "Could not register user",
                            message: "\(error.message) [\(error.rawValue) - \(error.rawString)]",
                            preferredStyle: UIAlertController.Style.alert)

                        alert.addAction(UIAlertAction(title: "Ok",
                                                      style: .cancel) {  _ in
                            alert.dismiss(animated: true, completion: nil)
                        })

                        UIApplication.mainWindow?.rootViewController?.present(alert, animated: true,
                                                                 completion: nil)
                    }
                }

            }

            let alert = UIAlertController(title: "Register user", message: "Enter a unique ID (or leave empty to generate) and a nickname", preferredStyle: .alert)

            alert.addTextField { (textField) in
                textField.text = ""
                textField.placeholder = "unique ID"
            }

            alert.addTextField { (textField) in
                textField.text = ""
                textField.placeholder = "nickname"
            }

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                if
                    let textField1 = alert?.textFields?[0],
                    let textField2 = alert?.textFields?[1] {

                    var uniqueId: String? = textField1.text
                    var nickname: String? = textField2.text

                    if uniqueId?.count == 0 { uniqueId = nil }
                    if nickname?.count == 0 { nickname = nil }

                    registerUser(uniqueId: uniqueId, nickname: nickname)
                }
            }))

            alert.addAction(UIAlertAction(title: "Cancel",
                                          style: .cancel) {  _ in
                alert.dismiss(animated: true, completion: nil)
            })


            UIApplication.mainWindow?.rootViewController?.present(alert, animated: true, completion: {})
        }

        optionsViewController?.newChannelTap = {
            self.addChannelTapped()
        }

        optionsViewController?.openLastChannelMessagesTap = {
            self.closeChannelController.openChannelMessagesView(channelId: nil, window: nil)
        }

        optionsViewController?.openLastChannelInfoTap = {
            self.closeChannelController.openChannelInfoView(channelId: nil, window: nil)
        }

        optionsViewController?.storePropertyTap = {
            func storeProperty(_ name: String, _ value: String) {
                self.closeChannelController.storeChannelProperties(properties: [name: value], channelId: nil) {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(
                            title: "Value \(value) for property \(name) saved",
                            message: nil,
                            preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                            alert.dismiss(animated: true)
                        })
                        UIApplication.mainWindow?.rootViewController?.present(alert, animated: true)
                    }
                } failure: { error in
                    DispatchQueue.main.async {
                        let alert = UIAlertController(
                            title: "Could not store property",
                            message: "\(error.message) [\(error.rawValue) - \(error.rawString)]",
                            preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel) { _ in
                            alert.dismiss(animated: true)
                        })
                        UIApplication.mainWindow?.rootViewController?.present(alert, animated: true)
                    }
                }
            }

            let alert = UIAlertController(title: "Store Channel Property", message: nil, preferredStyle: .alert)
            alert.addTextField { textField in
                textField.placeholder = "property name"
            }

            alert.addTextField { (textField) in
                textField.placeholder = "property value"
            }
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] _ in
                if let name = alert?.textFields?.first?.text,
                   let value = alert?.textFields?[1].text {
                    storeProperty(name, value)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) {  _ in
                alert.dismiss(animated: true, completion: nil)
            })
            UIApplication.mainWindow?.rootViewController?.present(alert, animated: true, completion: {})
        }

        optionsViewController?.showChannelViewControllerTap = {
            self.closeChannelController.getChannelMessagesViewController(channelId: nil) { channelMessagesViewController in
                channelMessagesViewController.title = "Talk to us"
                let navigationBar = UINavigationController(rootViewController: channelMessagesViewController)
                self.showChannelViewController(channelMessagesViewController)
                self.viewControllers?.last?.tabBarItem = UITabBarItem(title: "Messages", image: UIImage(named: "messages"), selectedImage: nil)

            } failure: { error in
                self.errorHandler(error)
            }
        }

        optionsViewController?.showInfoViewControllerTap = {
            self.closeChannelController.getChannelInfoViewController(channelId: nil) { channelInfoViewController in
                self.showChannelViewController(channelInfoViewController)
                self.viewControllers?.last?.tabBarItem = UITabBarItem(title: "Info", image: UIImage(named: "info"), selectedImage: nil)
            } failure: { error in
                self.errorHandler(error)
            }
        }
    }

    @objc fileprivate func addChannelTapped() {
        func addChannel(closeCode: String) {
            closeChannelController.addChannel(closeCode: closeCode) { channel in
                self.channelsTableViewController?.addChannel(channel)

                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "Channel with id \(channel.id) added",
                        message: nil,
                        preferredStyle: UIAlertController.Style.alert)

                    alert.addAction(UIAlertAction(title: "Ok",
                                                  style: .cancel) {  _ in
                        alert.dismiss(animated: true, completion: nil)
                    })

                    UIApplication.mainWindow?.rootViewController?.present(alert, animated: true,
                                                             completion: nil)
                }

            } failure: { error in
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "Could not add channel",
                        message: "\(error.message) [\(error.rawValue) - \(error.rawString)]",
                        preferredStyle: UIAlertController.Style.alert)

                    alert.addAction(UIAlertAction(title: "Ok",
                                                  style: .cancel) {  _ in
                        alert.dismiss(animated: true, completion: nil)
                    })

                    UIApplication.mainWindow?.rootViewController?.present(alert, animated: true,
                                                             completion: nil)
                }
            }
        }

        let alert = UIAlertController(title: "Add a channel", message: "Enter the Close code", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = ""
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if
                let textField = alert?.textFields?[0],
                let closeCode = textField.text {
                addChannel(closeCode: closeCode)
            }
        }))

        UIApplication.mainWindow?.rootViewController?.present(alert, animated: true, completion: {})
    }

    private func showChannelViewController(_ channelMessagesViewController: ChannelViewController) {
        if let index = self.viewControllers?.firstIndex(where: { $0.nameOfClass == channelMessagesViewController.nameOfClass
            || (($0 as? UINavigationController)?.viewControllers.contains(where: { $0.nameOfClass == channelMessagesViewController.nameOfClass }) == true )
        }) {
            self.viewControllers?.remove(at: index)
        }
        if let navigationController = channelMessagesViewController.navigationController {
            self.viewControllers?.append(navigationController)
        } else {
            self.viewControllers?.append(channelMessagesViewController)
        }
    }

    private func errorHandler(_ error: CloseChannelController.CloseChannelError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Could not retrieve",
                message: "\(error.message) [\(error.rawValue) - \(error.rawString)]",
                preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Ok",
                                          style: .cancel) {  _ in
                alert.dismiss(animated: true, completion: nil)
            })

            UIApplication.mainWindow?.rootViewController?.present(alert, animated: true,
                                                                  completion: nil)
        }
    }
}

extension NSObject {
    var nameOfClass: String {
        return NSStringFromClass(type(of: self))
    }
}

extension UIDevice {
    /// Returns `true` if the device has a notch
    var hasNotch: Bool {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
}
