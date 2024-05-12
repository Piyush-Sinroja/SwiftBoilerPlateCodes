//
//  LanguageManager.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/3/23.
//

import Foundation
import UIKit

enum Language: String, Equatable {
    case english
    case french
    case hindi
    case arebic
}

extension Language {
    var code: String {
        switch self {
        case .english: return "en"
        case .french: return "fr"
        case .hindi: return "hi"
        case .arebic: return "ar"
        }
    }

    var name: String {
        switch self {
        case .english: return "English"
        case .french: return "French"
        case .hindi: return "Hindi"
        case .arebic: return "Arabic"
        }
    }
}

extension Language {
    init?(languageCode: String?) {
        guard let languageCode = languageCode else { return nil }
        switch languageCode {
        case "en": self = .english
        case "fr": self = .french
        case "hi": self = .hindi
        case "ar": self = .arebic
        default: return nil
        }
    }
}

// MARK: localized String

extension String {
    var translated: String {
        NSLocalizedString(self, comment: "")
    }
    
    func translated(args: CVarArg...) -> String {
        return String(format: translated, arguments: args)
    }
}

private var bundleKey: UInt8 = 0

final class BundleExtension: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        return (objc_getAssociatedObject(self, &bundleKey) as? Bundle)?.localizedString(forKey: key, value: value, table: tableName) ?? super.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    static let once: Void = { object_setClass(Bundle.main, type(of: BundleExtension())) }()

    static func set(language: Language) {
        Bundle.once

        let isLanguageRTL = Locale.characterDirection(forLanguage: language.code) == .rightToLeft
        UIView.appearance().semanticContentAttribute = isLanguageRTL == true ? .forceRightToLeft : .forceLeftToRight

        UserDefaults.standard.set(isLanguageRTL, forKey: "AppleTe  zxtDirection")
        UserDefaults.standard.set(isLanguageRTL, forKey: "NSForceRightToLeftWritingDirection")
        UserDefaults.standard.set([language.code], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()

        guard let path = Bundle.main.path(forResource: language.code, ofType: "lproj") else {
            print("Failed to get a bundle path.")
            return
        }

        objc_setAssociatedObject(Bundle.main, &bundleKey, Bundle(path: path), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
