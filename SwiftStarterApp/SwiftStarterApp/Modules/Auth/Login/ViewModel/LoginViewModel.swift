//
//  LoginViewModel.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/8/23.
//

import Foundation

class LoginViewModel {
    // MARK: - Properties

    private let manager = UserManager()
}

// MARK: - User Login Using CoredataBase

extension LoginViewModel {
    @MainActor
    func login(with email: String, password: String) async throws {
        // Fetch User Data from CoreData
        let userList = await manager.fetchUser()

        guard !userList.isEmpty else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: LocalizedKey.UserNotFound.localized()])
        }

        guard (userList.filter { $0.email == email }.first) != nil else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: LocalizedKey.UserNotFound.localized()])
        }

        guard let user = userList.filter({ $0.password == password }).first else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: LocalizedKey.InvalidCredentials.localized()])
        }

        StorageService.shared.isUserConnected = true
        StorageService.shared.userID = user.id.uuidString
        AppConfiguration.shared.setRootVC()
    }
}

// MARK: - SignIn With AWS Amplify

extension LoginViewModel {
    @MainActor
    func signInWithAmplify(username: String, password: String) async throws {
        do {
            await AwsAuthManager.shared.signOutLocally()
            try await AwsAuthManager.shared.signIn(username: username, password: password)
            try await AwsAuthManager.shared.getUserName()
            
            StorageService.shared.isUserConnected = true
            AppConfiguration.shared.setRootVC()        
        } catch {
            throw error
        }
    }
}
