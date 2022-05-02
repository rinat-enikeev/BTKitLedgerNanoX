//
//  ViewController.swift
//  BTKitLedgerNanoX
//
//  Created by Rinat Enikeev on 01.05.2022.
//

import UIKit
import BTKit

class ViewController: UIViewController {

    @IBOutlet weak var progressLabel: UILabel!
    
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

                let progress: ((BTServiceProgress) -> Void)? = { progress in
                    switch progress {
                    case .connecting:
                        self.progressLabel.text = "connecting..."
                    case .disconnecting:
                        self.progressLabel.text = "disconnecting..."
                    case .serving:
                        self.progressLabel.text = "serving..."
                    case .reading:
                        self.progressLabel.text = "reading..."
                    case .success:
                        self.progressLabel.text = "success"
                    case let .failure(error):
                        self.progressLabel.text = error.localizedDescription
                    }
                }

                // this is core methods
                let nanoX = try await ledger.first(self)
                let address = try await nanoX.address(self, progress: progress)

                self.addressLabel.text = address.address
                self.activityIndicator.isHidden = true
                self.readButton.isEnabled = true
            } catch {
                self.activityIndicator.isHidden = true
                self.readButton.isEnabled = true
                self.addressLabel.text = error.localizedDescription
            }
        }
    }
}

