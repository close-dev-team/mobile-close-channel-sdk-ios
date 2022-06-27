//
//  OptionsViewController.swift
//  CloseChannelClient
//
//  Created by Close BV de Bijl on 5/24/22.
//

import UIKit

class OptionsViewController: UIViewController {

    var newChannelTap: (() -> Void)?
    var openLastChannelMessagesTap: (() -> Void)?
    var openLastChannelInfoTap: (() -> Void)?
    var registerUserTap: (() -> Void)?

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
