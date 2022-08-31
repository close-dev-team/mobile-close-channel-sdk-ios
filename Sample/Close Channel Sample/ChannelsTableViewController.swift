//
//  ChannelsTableViewController.swift
//  CloseChannelClient
//
//  Created by Close BV on 21/04/2022.
//

import UIKit
import CloseChannel

class ChannelsTableViewController: UITableViewController {
    let closeChannelController = CloseChannelController.sharedInstance
    var channels = [Channel]()
    let activityIndicatorView = UIActivityIndicatorView()

    func addChannel(_ channel: Channel) {
        channels.append(channel)

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.backgroundColor = .white

        view.addSubview(activityIndicatorView)

        refreshChannels()
    }

    private func refreshChannels() {
        func completed() {
            activityIndicatorView.stopAnimating()
            activityIndicatorView.removeFromSuperview()
        }

        if #available(iOS 13, *) {
            activityIndicatorView.style = .large
            activityIndicatorView.color = .black
        } else {
            activityIndicatorView.style = .whiteLarge
            activityIndicatorView.color = .black
        }

        activityIndicatorView.center = view.center
        activityIndicatorView.startAnimating()

#if !SDK_PERFORMANCE_TEST
        closeChannelController.getChannels { [weak self] channels in
            self?.channels = channels
            DispatchQueue.main.async {
                completed()
                self?.tableView.reloadData()
            }
        } failure: { [weak self] error in
            print("Error: could not get channels: \(error.message)")
            DispatchQueue.main.async {
                completed()
                let alert = UIAlertController(
                    title: "Could not retrieve list of channels",
                    message: "\(error.message) [\(error.rawValue) - \(error.rawString)]",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel) { _ in
                    alert.dismiss(animated: true, completion: nil)
                })
                self?.present(alert, animated: true)
            }
        }
#endif
    }

    fileprivate func channel(fromRow row: Int) -> Channel? {
        if channels.count >= row - 1{
            return channels[row]
        } else {
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelTableViewCell") as? ChannelTableViewCell {
            if let channel = channel(fromRow: indexPath.row) {
                cell.eventNameLabel?.text = channel.name

                cell.dayLabel?.text = channel.startDateTime.dayOfMonth()
                cell.monthLabel?.text = channel.startDateTime.threeLetterMonth()
                cell.unreadMessagesLabel?.text = "\(channel.unreadMessages)"
                cell.unreadMessagesLabel?.layer.cornerRadius = 16
                cell.unreadMessagesLabel?.layer.masksToBounds = true
                cell.unreadMessagesLabel?.isHidden = (channel.unreadMessages == 0)

                if let url = channel.profileImageUrl,
                   let data = try? Data(contentsOf: url) {
                    cell.profileImageView?.image = UIImage(data: data)
                    cell.profileImageView?.contentMode = .scaleAspectFit
                } else {
                    cell.profileImageView?.image = nil
                }

                if let url = channel.backgroundImageUrl,
                   let data = try? Data(contentsOf: url) {
                    cell.backgroundImageView?.image = UIImage(data: data)
                    cell.backgroundImageView?.alpha = 0.2
                    cell.backgroundImageView?.contentMode = .scaleAspectFill
                } else {
                    cell.backgroundImageView?.image = nil
                }
            }
            return cell
        }

        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let channel = channel(fromRow: indexPath.row) {

            let alert = UIAlertController(
                title: "Open chat or info view?",
                message: nil,
                preferredStyle: UIAlertController.Style.alert)

            print("***** \(channel.id)")

            alert.addAction(UIAlertAction(title: "Messages",
                                          style: .default) { [weak self] _ in
                print("***** \(channel.id)")
                self?.closeChannelController.openChannelMessagesView(channelId: channel.id, window: nil)
            })

            alert.addAction(UIAlertAction(title: "Info",
                                          style: .default) {  [weak self] _ in
                print("***** \(channel.id)")
                self?.closeChannelController.openChannelInfoView(channelId: channel.id, window: nil)
            })

            alert.addAction(UIAlertAction(title: "Show channel ID",
                                          style: .default) { _ in


                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "Channel ID",
                        message: channel.id,
                        preferredStyle: UIAlertController.Style.alert)

                    alert.addAction(UIAlertAction(title: "Close",
                                                  style: .cancel) {  _ in
                        alert.dismiss(animated: true, completion: nil)
                    })

                    alert.addAction(UIAlertAction(title: "Copy",
                                                  style: .default) {  _ in
                        UIPasteboard.general.string = channel.id
                    })

                    UIApplication.mainWindow?.rootViewController?.present(alert, animated: true,
                                                             completion: nil)
                }

            })

            alert.addAction(UIAlertAction(title: "Remove channel",
                                          style: .default) { [weak self] _ in
//                self?.closeChannelController.removeChannel(channelId: channel.id, success: {
//                    DispatchQueue.main.async {
//                        self?.refreshChannels()
//                    }
//                })
            })

            alert.addAction(UIAlertAction(title: "Cancel",
                                          style: .cancel) {  _ in
                alert.dismiss(animated: true, completion: nil)
            })


            self.present(alert, animated: true,
                         completion: nil)
        }
    }
}

extension Date {

    func threeLetterMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MMM"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        let month = dateFormatter.string(from: self)
        let index = month.index(month.startIndex, offsetBy: 3)
        return String(month[..<index])
    }

    func dayOfMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "d"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        return dateFormatter.string(from: self)
    }
}
