//
//  LoginViewController.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/8/23.
//

import UIKit
import Amplify

class LoginViewController: UIViewController {
    // MARK: - Properties

    var viewModel: LoginViewModel = .init()
    private let manager: UserManager = .init()

    // MARK: - IBOutlets

    @IBOutlet var emailTextField: UITextField! {
        didSet {
            emailTextField.placeholder = LocalizedKey.Email.localized()
            emailTextField.keyboardType = .emailAddress
        }
    }

    @IBOutlet var passwordTextField: UITextField! {
        didSet {
            passwordTextField.placeholder = LocalizedKey.Password.localized()
            passwordTextField.enablePasswordToggle()
        }
    }

    @IBOutlet var loginTitleLable: UILabel! {
        didSet {
            loginTitleLable.text = LocalizedKey.Login.localized()
            loginTitleLable.font = .openSans(of: 33, in: .bold)
            loginTitleLable.textColor = .hex_000000_Black
        }
    }

    @IBOutlet var loginButton: ReusableButton! {
        didSet {
            loginButton.viewModel = ReusableButtonViewModel(
                title: LocalizedKey.Login.localized(),
                titleColor: .hex_808080_White,
                backgroundColor: .hex_000000_Black,
                cornerRadius: 8,
                font: .openSans(of: 16, in: .semiBold)
            )
            loginButton.tapped = { [weak self] in
                self?.loginButtonAction()
            }
        }
    }

    @IBOutlet var forgotPasswordButton: ReusableButton! {
        didSet {
            forgotPasswordButton.viewModel = ReusableButtonViewModel(
                title: LocalizedKey.Forgot_Password.localized(),
                titleColor: .hex_000000_Black,
                backgroundColor: .green,
                cornerRadius: 8,
                font: UIFont.openSans(of: 16, in: .semiBold),
                textAlignment: .trailing,
                underlined: true
            )
            forgotPasswordButton.tapped = { [weak self] in
                self?.forgotPasswordButtonAction()
            }
        }
    }

    @IBOutlet var signUpButton: ReusableButton! {
        didSet {
            signUpButton.viewModel = ReusableButtonViewModel(
                title: LocalizedKey.Signup.localized(),
                titleColor: .hex_808080_White,
                backgroundColor: .black,
                cornerRadius: 8,
                font: UIFont.openSans(of: 16, in: .semiBold)
            )
            signUpButton.tapped = { [weak self] in
                self?.signupButtonAction()
            }
        }
    }
}

// MARK: - View Life Cycle

extension LoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: SET UI

    func setUI() {
        let prefferedLanguage = Localize.currentLanguage()
        if prefferedLanguage == Language.arebic.code {
            emailTextField.textAlignment = .right
            passwordTextField.textAlignment = .right
        } else {
            emailTextField.textAlignment = .left
            passwordTextField.textAlignment = .left
        }
    }
}

// MARK: - IBActions

extension LoginViewController {
    func loginButtonAction() {
        validate()
    }

    func signupButtonAction() {
        // Navigate to Signup Screen
        let vc = SignupViewController.instantiate(appStoryboard: .auth)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func forgotPasswordButtonAction() {
        // Navigate to Forgot Password Screen
    }

    func validate() {
        do {
            _ = try emailTextField.validatedText(validationType: ValidatorType.email)
            _ = try passwordTextField.validatedText(validationType: ValidatorType.password)
//            login()
            loginWithAmplify()
        } catch {
            self.showAlert(andMessage: (error as! ValidationError).message)
        }
    }

    private func login() {
        self.setLoading(true)
        Task {
            do {
                _ = try await self.viewModel.login(with: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "")
                self.setLoading(false)
            } catch {
                self.setLoading(false)
                self.showAlert(andMessage: error.localizedDescription)
            }
        }
    }
}

// MARK: - SignIn With AWS Amplify
extension LoginViewController {
    @MainActor
    private func loginWithAmplify() {
        self.setLoading(true)
        Task {
            do {
                _ = try await viewModel.signInWithAmplify(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "")
                Logger.log("******* Login Success *******")
                self.setLoading(false)
                
            } catch let error {
                self.setLoading(false)
                guard let error = error as? AuthError else {
                    return
                }
                self.showAlert(andMessage: error.errorDescription)
            }
        }
    }
}
