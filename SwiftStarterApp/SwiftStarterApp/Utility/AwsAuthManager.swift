//
//  AwsAuthManager.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 19/12/23.
//

import Amplify
import AWSPluginsCore
import AWSCognitoAuthPlugin
import Foundation
// https://docs.amplify.aws/swift/build-a-backend/auth/multi-step-sign-in/#confirm-signin-with-new-password

class AwsAuthManager {

    static let shared: AwsAuthManager = {
        let instance = AwsAuthManager()
        // Setup code
        return instance
    }()

    // MARK: - Sign In

    /// Sign in user (This is main sign in method)
    /// - Parameters:
    ///   - username: username
    ///   - password: password
    func signIn(username: String, password: String) async throws {
//        Task {
            do {
                let signInResult = try await Amplify.Auth.signIn(username: username, password: password)
                switch signInResult.nextStep {
                    case .confirmSignInWithSMSMFACode(let deliveryDetails, let info):
                        Logger.log("confirmSignInWithSMSMFACode: SMS code send to \(deliveryDetails.destination)")
                        Logger.log("confirmSignInWithSMSMFACode: Additional info \(String(describing: info))")

                        // If the next step is confirmSignInWithSMSMFACode, Amplify Auth has sent the user a random code over SMS, and is waiting to find out if the user successfully received it. To handle this step, your app's UI must prompt the user to enter the code. After the user enters the code, your implementation must pass the value to Amplify Auth confirmSignIn API.

                        // Note: the signin result also includes an AuthCodeDeliveryDetails member. It includes additional information about the code delivery such as the partial phone number of the SMS recipient.

                        // Prompt the user to enter the SMSMFA code they received
                        // Then invoke `confirmSignIn` api with the code

                    case .confirmSignInWithTOTPCode:
                        Logger.log("confirmSignInWithTOTPCode: Received next step as confirm sign in with TOTP code")

                        // If the next step is confirmSignInWithTOTPCode, you should prompt the user to enter the TOTP code from their associated authenticator app during set up. The code is a six-digit number that changes every 30 seconds. The user must enter the code before the 30-second window expires.
                        // After the user enters the code, your implementation must pass the value to Amplify Auth confirmSignIn API.

                        // Prompt the user to enter the TOTP code generated in their authenticator app
                        // Then invoke `confirmSignIn` api with the code

                    case .continueSignInWithTOTPSetup(let setUpDetails):
                        Logger.log("continueSignInWithTOTPSetup: Received next step as continue sign in by setting up TOTP")
                        Logger.log("continueSignInWithTOTPSetup: Shared secret that will be used to set up TOTP in the authenticator app \(setUpDetails.sharedSecret)")

                        // If the next step is continueSignInWithTOTPSetup, then the user must provide a TOTP code to complete the sign in process. The step returns an associated value of type TOTPSetupDetails which would be used for generating TOTP. TOTPSetupDetails provides a helper method called getSetupURI that can be used to generate a URI, which can be used by native password managers for TOTP association. For example. if the URI is used on Apple platforms, it will trigger the platform's native password manager to associate TOTP with the account. For more advanced use cases, TOTPSetupDetails also contains the sharedSecret that will be used to either generate a QR code or can be manually entered into an authenticator app.

                        // Once the authenticator app is set up, the user can generate a TOTP code and provide it to the library to complete the sign in process.

                        // Prompt the user to enter the TOTP code generated in their authenticator app
                        // Then invoke `confirmSignIn` api with the code

                    case .continueSignInWithMFASelection(let allowedMFATypes):
                        Logger.log("continueSignInWithMFASelection: Received next step as continue sign in by selecting MFA type")
                        Logger.log("continueSignInWithMFASelection: Allowed MFA types \(allowedMFATypes)")

                        // If the next step is continueSignInWithMFASelection, the user must select the MFA method to use. Amplify Auth currently only supports SMS and TOTP as MFA methods. After the user selects an MFA method, your implementation must pass the selected MFA method to Amplify Auth using confirmSignIn API.

                        // Prompt the user to select the MFA type they want to use
                        // Then invoke `confirmSignIn` api with the MFA type

                    case .confirmSignInWithCustomChallenge(let info):
                        Logger.log("confirmSignInWithCustomChallenge: ustom challenge, additional info \(String(describing: info))")

                        // If the next step is confirmSignInWithCustomChallenge, Amplify Auth is awaiting completion of a custom authentication challenge. The challenge is based on the Lambda trigger you setup when you configured a custom sign in flow. To complete this step, you should prompt the user for the custom challenge answer, and pass the answer to the confirmSignIn API.
                        // Prompt the user to enter custom challenge answer
                        // Then invoke `confirmSignIn` api with the answer

                    case .confirmSignInWithNewPassword(let info):
                        Logger.log("confirmSignInWithNewPassword: New password additional info \(String(describing: info))")

                        // If the next step is confirmSignInWithNewPassword, Amplify Auth requires a new password for the user before they can proceed. Prompt the user for a new password and pass it to the confirmSignIn API.

                        // Prompt the user to enter a new password
                        // Then invoke `confirmSignIn` api with new password

                        await confirmSignIn(newPasswordFromUser: "123@Piyush")

                    case .resetPassword(let info):
                        Logger.log("resetPassword: Reset password additional info \(String(describing: info))")

                        // If you receive resetPassword, authentication flow could not proceed without resetting the password. The next step is to invoke resetPassword api and follow the reset password flow.

                        // User needs to reset their password.
                        // Invoke `resetPassword` api to start the reset password flow, and once reset password flow completes, invoke `signIn` api to trigger signin flow again.

                    case .confirmSignUp(let info):
                        Logger.log("confirmSignUp: Confirm signup additional info \(String(describing: info))")

                        // If you receive confirmSignUp as a next step, sign up could not proceed without confirming user information such as email or phone number. The next step is to invoke the confirmSignUp API and follow the confirm signup flow.

                        // User was not confirmed during the signup process.
                        // Invoke `confirmSignUp` api to confirm the user if
                        // they have the confirmation code. If they do not have the confirmation code, invoke `resendSignUpCode` to send the code again.
                        // After the user is confirmed, invoke the `signIn` api again.
                    
                    case .done:
                        // Signin flow is complete when you get done. This means the user is successfully authenticated. As a convenience, the SignInResult also provides the isSignedIn property, which will be true if the next step is done.
                        Logger.log("done: Signin complete")
                        self.fetchUserSession { isSuccess, errorMessage, error in
                            Logger.log("isSuccess: \(isSuccess), errorMessage: \(errorMessage), error: \(String(describing: error?.localizedDescription))")
                        }
                }
            } catch let error as AuthError {
                Logger.log("Sign in failed \(error)")
                Logger.log("Sign in failed: \(error.errorDescription)")
                throw error
            } catch {
                Logger.log("SignIn Unexpected error: \(error)")
                throw error
            }
    }

    /// confirm sign in with confirmationCodeFromUser
    /// - Parameter confirmationCodeFromUser: confirmationCodeFromUser
    func confirmSignIn(confirmationCodeFromUser: String) async {
        do {
            let signInResult = try await Amplify.Auth.confirmSignIn(challengeResponse: confirmationCodeFromUser)
            if signInResult.isSignedIn {
                 Logger.log("Confirm sign in succeeded. The user is signed in.")
            } else {
                 Logger.log("Confirm sign in succeeded.")
                 Logger.log("Next step: \(signInResult.nextStep)")
                // Switch on the next step to take appropriate actions.
                // If `signInResult.isSignedIn` is true, the next step
                // is 'done', and the user is now signed in.
            }
        } catch let error as AuthError {
             Logger.log("Confirm sign in failed \(error)")
        } catch {
             Logger.log("Unexpected error: \(error)")
        }
    }

    /// confirm sign in with totpCode
    /// - Parameter totpCode: totpCode
    func confirmSignIn(otpCode: String) async throws {
        do {
            let signInResult = try await Amplify.Auth.confirmSignIn(challengeResponse: otpCode)
            if signInResult.isSignedIn {
                 Logger.log("Confirm sign in succeeded. The user is signed in.")
            } else {
                 Logger.log("Confirm sign in succeeded.")
                 Logger.log("Next step: \(signInResult.nextStep)")
                // Switch on the next step to take appropriate actions.
                // If `signInResult.isSignedIn` is true, the next step
                // is 'done', and the user is now signed in.
            }
        } catch {
             Logger.log("Confirm sign in failed \(error)")
            throw error
        }
    }

    /// confirm sign in with totpCodeFromAuthenticatorApp
    /// - Parameter totpCodeFromAuthenticatorApp: totpCodeFromAuthenticatorApp
    func confirmSignInWithTOTPSetup(totpCodeFromAuthenticatorApp: String) async {
        do {
            let signInResult = try await Amplify.Auth.confirmSignIn(
                challengeResponse: totpCodeFromAuthenticatorApp)

            if signInResult.isSignedIn {
                 Logger.log("Confirm sign in succeeded. The user is signed in.")
            } else {
                 Logger.log("Confirm sign in succeeded.")
                 Logger.log("Next step: \(signInResult.nextStep)")
                // Switch on the next step to take appropriate actions.
                // If `signInResult.isSignedIn` is true, the next step
                // is 'done', and the user is now signed in.
            }
        } catch {
             Logger.log("Confirm sign in failed \(error)")
        }
    }

    /// confirm sign in with TOTPAsMFASelection
    func confirmSignInWithTOTPAsMFASelection() async {
        do {
            let signInResult = try await Amplify.Auth.confirmSignIn(
                challengeResponse: MFAType.totp.challengeResponse)

            if case .confirmSignInWithTOTPCode = signInResult.nextStep {
                 Logger.log("Received next step as confirm sign in with TOTP")
            }

        } catch {
             Logger.log("Confirm sign in failed \(error)")
        }
    }

    /// confirm sign in with challengeAnswerFromUser
    /// - Parameter challengeAnswerFromUser: challengeAnswerFromUser
    func confirmSignIn(challengeAnswerFromUser: String) async {
        do {
            let signInResult = try await Amplify.Auth.confirmSignIn(challengeResponse: challengeAnswerFromUser)
            if signInResult.isSignedIn {
                 Logger.log("Confirm sign in succeeded. The user is signed in.")
            } else {
                 Logger.log("Confirm sign in succeeded.")
                 Logger.log("Next step: \(signInResult.nextStep)")
                // Switch on the next step to take appropriate actions.
                // If `signInResult.isSignedIn` is true, the next step
                // is 'done', and the user is now signed in.
            }
        } catch let error as AuthError {
             Logger.log("Confirm sign in failed \(error)")
        } catch {
             Logger.log("Unexpected error: \(error)")
        }
    }

    /// confirm sign in with new password
    /// - Parameter newPasswordFromUser: newPasswordFromUser
    func confirmSignIn(newPasswordFromUser: String) async {
        do {
            let signInResult = try await Amplify.Auth.confirmSignIn(challengeResponse: newPasswordFromUser)
            if signInResult.isSignedIn {
                 Logger.log("Confirm sign in succeeded. The user is signed in.")
            } else {
                 Logger.log("Confirm sign in succeeded.")
                 Logger.log("Next step: \(signInResult.nextStep)")
                // Switch on the next step to take appropriate actions.
                // If `signInResult.isSignedIn` is true, the next step
                // is 'done', and the user is now signed in.
            }
        } catch let error as AuthError {
             Logger.log("Confirm sign in failed \(error)")
        } catch {
             Logger.log("Unexpected error: \(error)")
        }
    }

    // MARK: - Sign Up

    /// sign up
    /// - Parameters:
    ///   - username: Resend verification code
    ///   - password: user password
    ///   - email: user email
    func signUp(username: String, password: String, email: String) async throws {
        let userAttributes = [AuthUserAttribute(.preferredUsername, value: username)]
        
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        do {
            let signUpResult = try await Amplify.Auth.signUp(
                username: email,
                password: password,
                options: options
            )
            if case let .confirmUser(deliveryDetails, _, userId) = signUpResult.nextStep {
                StorageService.shared.set(signUpResult.userID ?? "", forKey: .userID)
                Logger.log("Delivery details \(String(describing: deliveryDetails)) for userId: \(String(describing: userId))")
            } else {
                Logger.log("SignUp Complete")
            }
        } catch let error as AuthError {
            Logger.log("An error occurred while registering a user \(error)")
            throw error
        } catch {
            Logger.log("Unexpected error: \(error)")
            throw error
        }
    }

    /// confirm sign up
    /// - Parameters:
    ///   - username: username
    ///   - confirmationCode: confirmationCode
    func confirmSignUp(for username: String, with confirmationCode: String) async throws {
        do {
            let confirmSignUpResult = try await Amplify.Auth.confirmSignUp(
                for: username,
                confirmationCode: confirmationCode
            )
            Logger.log("Confirm sign up result completed: \(confirmSignUpResult.isSignUpComplete)")
        } catch let error as AuthError {
            Logger.log("An error occurred while confirming sign up \(error)")
            throw error
        } catch {
            Logger.log("Unexpected error: \(error)")
            throw error
        }
    }

    // MARK: - Reset Password

    /// In order to reset your password, use the resetPassword api - this will send a code to the user attribute configured to receive such a reset code (e.g. email or SMS):
    /// - Parameter username: username
    func resetPassword(username: String) async {
        do {
            let resetResult = try await Amplify.Auth.resetPassword(for: username)
            switch resetResult.nextStep {
                case .confirmResetPasswordWithCode(let deliveryDetails, let info):
                     Logger.log("Confirm reset password with code send to - \(deliveryDetails) \(String(describing: info))")
                case .done:
                     Logger.log("Reset completed")
            }
        } catch let error as AuthError {
             Logger.log("Reset password failed with error \(error)")
        } catch {
             Logger.log("Unexpected error: \(error)")
        }
    }

    /// confirm reset password
    /// - Parameters:
    ///   - username: username
    ///   - newPassword: newPassword
    ///   - confirmationCode: confirmationCode
    func confirmResetPassword(username: String, newPassword: String, confirmationCode: String) async {
        do {
            try await Amplify.Auth.confirmResetPassword(
                for: username,
                with: newPassword,
                confirmationCode: confirmationCode
            )
             Logger.log("Password reset confirmed")
        } catch let error as AuthError {
             Logger.log("Reset password failed with error \(error)")
        } catch {
             Logger.log("Unexpected error: \(error)")
        }
    }

    // MARK: - Change Password

    /// change password
    /// - Parameters:
    ///   - oldPassword: user's oldPassword
    ///   - newPassword: user's newPassword
    func changePassword(oldPassword: String, newPassword: String) async {
        do {
            try await Amplify.Auth.update(oldPassword: oldPassword, to: newPassword)
             Logger.log("Change password succeeded")
        } catch let error as AuthError {
             Logger.log("Change password failed with error \(error)")
        } catch {
             Logger.log("Unexpected error: \(error)")
        }
    }

    // MARK: - Delete User

    /// delete current user
    func deleteUser() async {
        do {
            try await Amplify.Auth.deleteUser()
             Logger.log("Successfully deleted user")
        } catch let error as AuthError {
             Logger.log("Delete user failed with error \(error)")
        } catch {
             Logger.log("Unexpected error: \(error)")
        }
    }

    // MARK: - Resend verification code

    /// resend verification code to user's emailId
    func resendCode() async {
        do {
            let deliveryDetails = try await Amplify.Auth.sendVerificationCode(forUserAttributeKey: .email)
             Logger.log("Resend code send to - \(deliveryDetails)")
        } catch let error as AuthError {
             Logger.log("Resend code failed with error \(error)")
        } catch {
             Logger.log("Unexpected error: \(error)")
        }
    }

    // MARK: - Fetch User Session

    // fetch user session
    func fetchUserSession(completionHandler: @escaping (Bool, String, Error?) -> Void) {
        Task {
            do {
                let authSession = try await Amplify.Auth.fetchAuthSession()

                // Get user sub or identity id
                /*
                if let identityProvider = authSession as? AuthCognitoIdentityProvider {
                    let usersub = try identityProvider.getUserSub().get()
                    let identityId = try identityProvider.getIdentityId().get()
                    Logger.log("User sub - \(usersub) and identity id \(identityId)")
                }
                 */
                
                // Get AWS credentials
                /*
                if let awsCredentialsProvider = authSession as? AuthAWSCredentialsProvider {
                    let credentials = try awsCredentialsProvider.getAWSCredentials().get()
                    Logger.log("credentials \(credentials)")
                    // Do something with the credentials
                }
                 */

                // Get cognito user pool token
                if let cognitoTokenProvider = authSession as? AuthCognitoTokensProvider {
                    let tokens = try cognitoTokenProvider.getCognitoTokens().get()
                    let idToken = tokens.idToken
                    let accessToken = tokens.accessToken
                    let refreshToken = tokens.refreshToken

                    StorageService.shared.set(idToken, forKey: .idToken)
                    StorageService.shared.set(accessToken, forKey: .accessToken)
                    StorageService.shared.set(refreshToken, forKey: .refreshToken)

                    let tokenType = "Bearer"
                    StorageService.shared.set("\(tokenType) \(idToken)", forKey: .headerAuth)
                    completionHandler(true, "", nil)
                }
//                guard !checkIsIdTokenValid(idToken: StorageService.shared.string(.idToken) ?? "") else {
//                    Logger.log("checkIsIdTokenValid: true")
//                    return
//                }
            } catch let error as AuthError {
                Logger.log("Refresh Token Auth Error: \(error.errorDescription)")
                switch error {
                    case .configuration(let errorDescription, let recoverySuggestion, let error):
                        Logger.log("Refresh Token Auth configuration Error- \(errorDescription) +++ \(recoverySuggestion) +++ \(String(describing: error))")
                        completionHandler(false, "\(errorDescription)", error)
                    case .service(let errorDescription, let recoverySuggestion, let error):
                        Logger.log("Refresh Token Auth service Error- \(errorDescription) +++ \(recoverySuggestion) +++ \(String(describing: error))")
                        completionHandler(false, "\(errorDescription)", error)
                    case .unknown(let errorDescription, let error):
                        Logger.log("Refresh Token Auth unknown Error- \(errorDescription) +++ \(String(describing: error))")
                        completionHandler(false, "\(errorDescription)", error)

                    case .validation(let field, let errorDescription, let recoverySuggestion, let error):
                        Logger.log("Refresh Token Auth validation Error- \(field) +++ \(errorDescription) +++ \(recoverySuggestion) +++ \(String(describing: error))")
                        completionHandler(false, "\(errorDescription)", error)

                    case .notAuthorized(let errorDescription, let recoverySuggestion, let error):
                        Logger.log("Refresh Token Auth notAuthorized Error- \(errorDescription) +++ \(recoverySuggestion) +++ \(String(describing: error))")
                        completionHandler(false, "\(errorDescription)", error)
                    case .invalidState(let errorDescription, let recoverySuggestion, let error):
                        Logger.log("Refresh Token Auth invalidState Error- \(errorDescription) +++ \(recoverySuggestion) +++ \(String(describing: error))")
                        completionHandler(false, "\(errorDescription)", error)
                    case .signedOut(let errorDescription, let recoverySuggestion, let error):
                        Logger.log("Refresh Token Auth signedOut Error- \(errorDescription) +++ \(recoverySuggestion) +++ \(String(describing: error))")
                        completionHandler(false, "\(errorDescription)", error)
                    case .sessionExpired(let errorDescription, let recoverySuggestion, let error):
                        Logger.log("Refresh Token Auth sessionExpired Error- \(errorDescription) +++ \(recoverySuggestion) +++ \(String(describing: error))")
                }
            } catch {
                Logger.log("Refresh Token Auth Error- \(error.localizedDescription)")
                completionHandler(false, error.localizedDescription, error)
            }
        }
    }

    // MARK: - SignOut

    // SignOut User locally from Cognito
    func signOutLocally() async {
        let result = await Amplify.Auth.signOut()
        guard let signOutResult = result as? AWSCognitoSignOutResult else {
            Logger.log("Signout failed")
            return
        }
        switch signOutResult {
            case .complete:
                Logger.log("Signed out successfully")
            case let .partial(revokeTokenError, globalSignOutError, hostedUIError):
                if let hostedUIError = hostedUIError {
                    Logger.log("HostedUI error  \(hostedUIError)")
                }
                if let globalSignOutError = globalSignOutError {
                    Logger.log("GlobalSignOut error  \(globalSignOutError)")
                }
                if let revokeTokenError = revokeTokenError {
                    Logger.log("Revoke token error  \(revokeTokenError)")
                }
            case .failed(let error):
                // Sign Out failed with an exception, leaving the user signed in.
                Logger.log("SignOut failed with \(error)")
        }
    }

    //SignOut User globally
    func signOutGlobally() async {
        let result = await Amplify.Auth.signOut(options: .init(globalSignOut: true))
        guard let signOutResult = result as? AWSCognitoSignOutResult else {
            Logger.log("Signout failed")
            return
        }

        Logger.log("Global signout successful: \(signOutResult.signedOutLocally)")
        switch signOutResult {
            case .complete:
                Logger.log("Signed out successfully")

            case let .partial(revokeTokenError, globalSignOutError, hostedUIError):

                if let hostedUIError = hostedUIError {
                    Logger.log("HostedUI error  \(hostedUIError)")
                }

                if let globalSignOutError = globalSignOutError {
                    Logger.log("GlobalSignOut error  \(globalSignOutError)")
                }

                if let revokeTokenError = revokeTokenError {
                    Logger.log("Revoke token error  \(revokeTokenError)")
                }

            case .failed(let error):
                // Sign Out failed with an exception, leaving the user signed in.
                Logger.log("SignOut failed with \(error)")
        }
    }

    // MARK: - Helper Method

    /// check isIdToken Valid or not
    /// - Parameter idToken: idToken string value
    /// - Returns: pass true if idToken is not expired otherwise false
    func checkIsIdTokenValid(idToken: String) -> Bool {
        // check idToken empty or not
        guard !idToken.isEmpty else {
            return false
        }

        // get array of payload values by separating from .
        let arrPayloadValues = idToken.components(separatedBy: ".")
        guard arrPayloadValues.count > 1 else {
            return false
        }

        // get the payload part of it
        var payload64 = arrPayloadValues[1]

        // need to pad the string with = to make it divisible by 4,
        // otherwise Data won't be able to decode it
        while payload64.count % 4 != 0 {
            payload64 += "="
        }

        print("base64 encoded payload: \(payload64)")

        guard let payloadData = Data(base64Encoded: payload64, options: .ignoreUnknownCharacters),
              let payload = String(data: payloadData, encoding: .utf8),
              !payload.isEmpty,
              let json = try? JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any],
              let exp = json["exp"] as? Int else {
            return false
        }

        print(payload)

        // get expiration date from exp time interval of idToken
        let expDate = Date(timeIntervalSince1970: TimeInterval(exp))
        print("Token expDate", expDate)

        // add 2 min to current date
        guard let currentDateWith2minAdd = Calendar.current.date(byAdding: .minute, value: +2, to: Date()) else {
            return false
        }

        print("currentDateWith2minAdd", currentDateWith2minAdd)

        // check currentDateWith2minAdd < expDate as we have checking with orderedDescending
        let isValid = expDate.compare(currentDateWith2minAdd) == .orderedDescending
        print("isValid Token", isValid)

        return isValid
    }
    
    func fetchAttributes() async throws -> [AuthUserAttribute] {
        do {
            let userDetails = try await Amplify.Auth.fetchUserAttributes()
            return userDetails
        } catch let error {
            Logger.log("Fetch Attributes Error- \(error.localizedDescription)")
            throw error
        }
    }
    
    func getUserName() async throws {
        do {
            let userDetails = try await Amplify.Auth.fetchUserAttributes()
            let username = userDetails.filter { $0.key == .preferredUsername }.first?.value ?? ""
            StorageService.shared.userName = username
        } catch let error {
            Logger.log("Fetch Attributes Error- \(error.localizedDescription)")
            throw error
        }
    }
    
}
