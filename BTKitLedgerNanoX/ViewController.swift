//
//  ViewController.swift
//  BTKitLedgerNanoX
//
//  Created by Rinat Enikeev on 01.05.2022.
//

import UIKit
import BTKit

class ViewController: UIViewController {
    @IBOutlet weak var addressLabel: UILabel!

    @IBOutlet weak var pairedButton: UIButton!

    @IBOutlet weak var openedButton: UIButton!

    @IBOutlet weak var readButton: UIButton!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBAction func pairedButtonTouchUpInside(_ sender: Any) {
        pairedButton.isHidden = true
        openedButton.isHidden = false
    }

    @IBAction func openedButtonTouchUpInside(_ sender: Any) {
        openedButton.isHidden = true
        readButton.isHidden = false
    }

    @IBAction func readButtonTouchUpInside(_ sender: Any) {
        Task {
            let ledger = BTKit.background.services.ledger
            do {
                self.readButton.isEnabled = false
                self.activityIndicator.isHidden = false
                let nanoX = try await ledger.first(self)
                let address = try await nanoX.address(self)
                self.addressLabel.text = address.address
                self.activityIndicator.isHidden = true
                self.readButton.isEnabled = false
            } catch {
                self.activityIndicator.isHidden = true
                self.readButton.isEnabled = true
                self.addressLabel.text = error.localizedDescription
            }
        }
    }
}

