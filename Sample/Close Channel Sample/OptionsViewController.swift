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

    @IBOutlet var sdkVersionLabel: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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

}
