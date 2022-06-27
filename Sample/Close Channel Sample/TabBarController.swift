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
        if let viewControllers = viewControllers {
            for viewController in viewControllers {
                switch viewController {
                case is ChannelsTableViewController:
                    channelsTableViewController = viewController as? ChannelsTableViewController
                case is OptionsViewController:
                    optionsViewController = viewController as? OptionsViewController
                default:
                    break
                }
            }
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
}
