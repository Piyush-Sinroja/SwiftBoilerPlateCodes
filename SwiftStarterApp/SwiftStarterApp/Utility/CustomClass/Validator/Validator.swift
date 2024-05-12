//
//  Validator.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/8/23.
//

import Foundation

class ValidationError: Error, LocalizedError {
    var message: String

    init(_ message: String) {
        self.message = message
    }
    var errorDescription: String? {
        return message
    }
}

protocol ValidatorConvertible {
    func validated(_ value: String) throws -> String
    func validated(_ password: String, _ confirmPassword: String) throws -> String
}

extension ValidatorConvertible {
    func validated(_ password: String, _ confirmPassword: String) throws -> String {
        return ""
    }

    func validated(_ value: String) throws -> String {
        return value
    }
}

enum ValidatorType {
    case email
    case password
    case confirmPassword
    case username
    case projectIdentifier
    case requiredField(field: String)
    case age
    case dob
}

enum ValidatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .email: return EmailValidator()
        case .password: return PasswordValidator()
        case .confirmPassword: return ConfirmPasswordValidator()
        case .username: return UserNameValidator()
        case .projectIdentifier: return ProjectIdentifierValidator()
        case .requiredField(let fieldName): return RequiredFieldValidator(fieldName)
        case .age: return AgeValidator()
        case .dob: return DOBValidator()
        }
    }
}

// "J3-123A" i.e
struct ProjectIdentifierValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        do {
            if try NSRegularExpression(pattern: "^[A-Z]{1}[0-9]{1}[-]{1}[0-9]{3}[A-Z]$", options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError("Invalid Project Identifier Format")
            }
        } catch {
            throw ValidationError("Invalid Project Identifier Format")
        }
        return value
    }
}

class AgeValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard !value.isEmpty else { throw ValidationError("Age is required") }
        guard let age = Int(value) else { throw ValidationError("Age must be a number!") }
        guard value.count < 3 else { throw ValidationError("Invalid age number!") }
        guard age >= 18 else { throw ValidationError("You have to be over 18 years old to user our app :)") }
        return value
    }
}

struct RequiredFieldValidator: ValidatorConvertible {
    private let fieldName: String

    init(_ field: String) {
        fieldName = field
    }

    func validated(_ value: String) throws -> String {
        guard !value.isEmpty else {
            throw ValidationError("Required field " + fieldName)
        }
        return value
    }
}

struct UserNameValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard !value.isEmpty else { throw ValidationError(LocalizedKey.Username_Required_Error.localized()) }

        guard value.count >= 3 else {
            throw ValidationError(LocalizedKey.Username_Morethen_Three_Characters_Error.localized())
        }
        guard value.count < 18 else {
            throw ValidationError(LocalizedKey.Username_Lessthen_Ten_Characters_Error.localized())
        }

        do {
            if try NSRegularExpression(pattern: "^[0-9a-zA-Z\\_]{7,18}$", options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError(LocalizedKey.Username_Whitespaces_Error.localized())
            }
        } catch {
            throw ValidationError(LocalizedKey.Username_Whitespaces_Error.localized())
        }
        return value
    }
}

struct PasswordValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard !value.isEmpty else { throw ValidationError(LocalizedKey.Password_Required_Error.localized()) }
        guard value.count >= 6 else { throw ValidationError(LocalizedKey.Password_Lenght_Error.localized()) }
        do {
            let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{6,255}"
            if try NSRegularExpression(pattern: regex, options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError(LocalizedKey.Password_With_Character_Number_Error.localized())
            }
        } catch {
            throw ValidationError(LocalizedKey.Password_With_Character_Number_Error.localized())
        }
        return value
    }
}

struct EmailValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard !value.isEmpty else { throw ValidationError(LocalizedKey.Email_Required_Error.localized()) }
        guard value.isValidEmailId() else { throw ValidationError(LocalizedKey.Invalid_Email_Address_Error.localized()) }
        return value
    }
}

struct ConfirmPasswordValidator: ValidatorConvertible {
    func validated(_ password: String, _ confirmPassword: String) throws -> String {
        guard password == confirmPassword else {
            throw ValidationError(LocalizedKey.Confirm_Password_Not_Matched_Error.localized())
        }
        return ""
    }
}

class DOBValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard !value.isEmpty else { throw ValidationError(LocalizedKey.DOB_Required_Error.localized()) }
        return value
    }
}
