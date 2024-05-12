//
//  SignupViewController.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/10/23.
//

import Amplify
import UIKit

class SignupViewController: UIViewController {
    // MARK: - IBOutlets

    var imagePicker: ImagePicker!
    var imageSelected = false

    private let viewModel: SignupViewModel = .init()

    @IBOutlet var userNameTextField: UITextField! {
        didSet {
            userNameTextField.placeholder = LocalizedKey.Username.localized()
            userNameTextField.autocapitalizationType = .words
        }
    }

    @IBOutlet var emailTextField: UITextField! {
        didSet {
            emailTextField.placeholder = LocalizedKey.Email.localized()
        }
    }

    @IBOutlet var dobTextField: UITextField! {
        didSet {
            dobTextField.placeholder = LocalizedKey.Date_Of_Birth.localized()
        }
    }

    @IBOutlet var passwordTextField: UITextField! {
        didSet {
            passwordTextField.placeholder = LocalizedKey.Password.localized()
            passwordTextField.enablePasswordToggle()
        }
    }

    @IBOutlet var confirmPasswordTextField: UITextField! {
        didSet {
            confirmPasswordTextField.placeholder = LocalizedKey.Confirm_Password.localized()
            confirmPasswordTextField.enablePasswordToggle()
        }
    }

    @IBOutlet var profileImageView: UIImageView! {
        didSet {
            profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.imageSelection(_:)))
            profileImageView.addGestureRecognizer(tap)
            profileImageView.isUserInteractionEnabled = true
        }
    }

    @IBOutlet var signupButton: ReusableButton! {
        didSet {
            signupButton.viewModel = ReusableButtonViewModel(
                title: LocalizedKey.Signup.localized(),
                titleColor: .hex_808080_White,
                backgroundColor: .hex_000000_Black,
                cornerRadius: 8,
                font: .openSans(of: 16, in: .semiBold)
            )
            signupButton.tapped = { [weak self] in
                self?.signupButtonAction()
            }
        }
    }
}

// MARK: - View life cycle

extension SignupViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = LocalizedKey.Signup.localized().uppercased()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)

        setDobTextField()
    }

    private func setDobTextField() {
        // Set DOB Picker
        self.dobTextField.datePicker(target: self,
                                     doneAction: #selector(doneAction),
                                     cancelAction: #selector(cancelAction),
                                     datePickerMode: .date,
                                     preferredDatePickerStyle: .wheels)
    }

    func validate() {
        do {
            _ = try userNameTextField.validatedText(validationType: ValidatorType.username)
            _ = try emailTextField.validatedText(validationType: ValidatorType.email)
            _ = try dobTextField.validatedText(validationType: ValidatorType.dob)
            _ = try passwordTextField.validatedText(validationType: ValidatorType.password)
            _ = try confirmPasswordTextField.validatedTextConfirPassword(validationType: ValidatorType.confirmPassword, password: passwordTextField.text ?? "", confirmPassword: confirmPasswordTextField.text ?? "")
            _ = try passwordTextField.validatedText(validationType: ValidatorType.password)

            let user = User(id: UUID(), username: userNameTextField.text ?? "",
                            email: emailTextField.text ?? "",
                            dob: dobTextField.text ?? "",
                            password: passwordTextField.text ?? "",
                            profilePic: profileImageView.image?.pngData())

            // Store User Details in CoreData
            viewModel.createUser(user: user)

            // SignUp With AWS Amplify
            signUpUserWithAmplify()
        } catch {
            let errorMessage = ValidationError(error.localizedDescription).message
            self.showAlert(andMessage: errorMessage)
        }
    }
}

// MARK: - Action

extension SignupViewController {
    func signupButtonAction() {
        validate()
    }
}

// MARK: - Date Picker

extension SignupViewController {
    @objc func cancelAction() {
        self.dobTextField.resignFirstResponder()
    }

    @objc func doneAction() {
        if let datePickerView = self.dobTextField.inputView as? UIDatePicker {
            self.dobTextField.text = datePickerView.date.stringFromDate()
            self.dobTextField.resignFirstResponder()
        }
    }
}

extension SignupViewController {
    @objc func imageSelection(_ sender: UITapGestureRecognizer? = nil) {
        self.imagePicker.present(from: self.view)
    }
}

// MARK: ImagePicker Delegate

extension SignupViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.profileImageView.image = image
        imageSelected = true
    }
}

// MARK: - User Signup With AWS Amplify

extension SignupViewController {
    func signUpUserWithAmplify() {
        Task {
            self.setLoading(true)
            do {
                try await viewModel.signUpUser(username: self.userNameTextField.text ?? "",
                                               password: self.passwordTextField.text ?? "",
                                               email: self.emailTextField.text ?? "")

                self.setLoading(false)
                let vc = OTPVerificationViewController.instantiate(appStoryboard: .auth)
                self.navigationController?.pushViewController(vc, animated: true)
            } catch {
                self.setLoading(false)
                guard let error = error as? AuthError else {
                    return
                }
                self.showAlert(andMessage: error.errorDescription)
            }
        }
    }
}
