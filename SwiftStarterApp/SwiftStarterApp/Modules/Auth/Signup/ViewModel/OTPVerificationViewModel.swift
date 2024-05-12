//
//  OTPVerificationViewModel.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 12/21/23.
//

import Foundation
import UIKit

class OTPVerificationViewModel {
    @MainActor
    func verifyOtpWithAmplify(username: String, otpCode: String) async throws {
        do {
            try await AwsAuthManager.shared.confirmSignUp(for: username, with: otpCode)
            AppConfiguration.shared.setRootVC()
        } catch {
            throw error
        }
    }
}
