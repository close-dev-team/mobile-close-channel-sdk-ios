//
//  OptionsViewController.swift
//  CloseChannelClient
//
//  Created by Close BV de Bijl on 5/24/22.
//

import UIKit
import CloseChannel

class OptionsViewController: UIViewController {
    let closeChannelController = CloseChannelController.sharedInstance

    var newChannelTap: (() -> Void)?
    var openLastChannelMessagesTap: (() -> Void)?
    var openLastChannelInfoTap: (() -> Void)?
    var registerUserTap: (() -> Void)?
    var storePropertyTap: (() -> Void)?
    var showChannelViewControllerTap: (() -> Void)?
    var showInfoViewControllerTap: (() -> Void)?

    @IBOutlet var sdkVersionLabel: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        title = "Options"

        sdkVersionLabel.textColor = .black
        sdkVersionLabel.text = "🔋 Powered by Close\nMobile Close Channel SDK \(closeChannelController.version)"
    }

    @IBAction func newChannelTapped() {
        newChannelTap?()
    }

    @IBAction func openLastChannelMessagesTapped() {
        openLastChannelMessagesTap?()
    }

    @IBAction func openLastChannelInfoTapped() {
        openLastChannelInfoTap?()
    }

    @IBAction func registerUserTapped() {
        registerUserTap?()
    }

    @IBAction func storePropertyTapped() {
        storePropertyTap?()
    }

    @IBAction func showChannelViewControllerTapped() {
        showChannelViewControllerTap?()
    }

    @IBAction func showInfoViewControllerTapped() {
        showInfoViewControllerTap?()
    }
}
