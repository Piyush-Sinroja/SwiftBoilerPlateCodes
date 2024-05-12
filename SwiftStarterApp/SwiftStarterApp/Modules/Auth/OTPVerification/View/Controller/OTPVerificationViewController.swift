//
//  OTPVerificationViewController.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 12/21/23.
//

import Amplify
import UIKit

class OTPVerificationViewController: UIViewController {
    let viewModel: OTPVerificationViewModel = .init()

    // MARK: - IBOutlets

    @IBOutlet var otpVerifyTextfield: UITextField! {
        didSet {
            otpVerifyTextfield.placeholder = LocalizedKey.Enter_OTP.localized()
            otpVerifyTextfield.keyboardType = .emailAddress
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = LocalizedKey.Please_Verify_OTP.localized()
    }

    @IBOutlet var verifyOtpButton: ReusableButton! {
        didSet {
            verifyOtpButton.viewModel = ReusableButtonViewModel(
                title: LocalizedKey.Verify_OTP.localized(),
                titleColor: .hex_808080_White,
                backgroundColor: .hex_000000_Black,
                cornerRadius: 8,
                font: .openSans(of: 16, in: .semiBold)
            )
            verifyOtpButton.tapped = { [weak self] in
                self?.verifyOtpButtonAction()
            }
        }
    }
}

extension OTPVerificationViewController {
    @MainActor
    private func verifyOtpButtonAction() {
        setLoading(true)
        Task {
            do {
                let username = StorageService.shared.userID ?? ""
                _ = try await viewModel.verifyOtpWithAmplify(username: username, otpCode: self.otpVerifyTextfield.text ?? "")
                Logger.log("******* Signup With Otp Success *******")
                self.setLoading(false)
            } catch {
                Logger.log("Error: \(error.localizedDescription)")
                self.setLoading(false)
                guard let error = error as? AuthError else {
                    return
                }
                self.showAlert(andMessage: error.errorDescription)
            }
        }
    }
}
