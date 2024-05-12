//
//  SignupViewModel.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/27/23.
//

import Foundation

class SignupViewModel {
    // MARK: - Properties

    private let manager: UserManager = .init()
}

// MARK: - User Create and Store in Core Database.

extension SignupViewModel {
    func createUser(user: User) {
        manager.createUser(user: user)
    }
}

// MARK: - User Signup With AWS Aplify

extension SignupViewModel {
    func signUpUser(username: String, password: String, email: String) async throws {
        do {
            _ = try await AwsAuthManager.shared.signUp(username: username, password: password, email: email)

        } catch let error {
            throw error
        }
    }
}
