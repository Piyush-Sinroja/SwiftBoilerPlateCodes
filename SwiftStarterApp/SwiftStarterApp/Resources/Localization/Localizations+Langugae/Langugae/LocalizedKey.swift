//
//  LocalizedStrings.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/6/23.
//

import Foundation

public enum LocalizedKey {
    static let AppName = "AppName"
    
    /// Login & Signup
    static let Login = "Login"
    static let Email = "Email"
    static let Password = "Password"
    static let Forgot_Password = "Forgot_Password"
            
    static let Signup = "Signup"
    static let Username = "Username"

    static let Date_Of_Birth = "Date_Of_Birth"
    static let Confirm_Password = "Confirm_Password"
    
    static let Logout = "Logout"
    
    /// Validation
    static let Email_Required_Error = "Email_Required_Error"
    static let Invalid_Email_Address_Error = "Invalid_Email_Address_Error"
    static let Password_Required_Error = "Password_Required_Error"
    static let Password_Lenght_Error = "Password_Lenght_Error"
    static let Confirm_Password_Not_Matched_Error = "Confirm_Password_Not_Matched_Error"
    static let Password_With_Character_Number_Error = "Password_With_Character_Number_Error"
    
    static let Username_Required_Error = "Username_Required_Error"
    static let Username_Morethen_Three_Characters_Error = "Username_Morethen_Three_Characters_Error"
    static let Username_Lessthen_Ten_Characters_Error = "Username_Lessthen_Ten_Characters_Error"
    static let Username_Whitespaces_Error = "Username_Whitespaces_Error"
    static let DOB_Required_Error = "DOB_Required_Error"
    static let UserNotFound = "UserNotFound"
    static let InvalidCredentials = "InvalidCredentials"
         
    // Tabs
    static let Home = "Home"
    static let Menu = "Menu"
    static let Search = "Search"
    static let Profile = "Profile"
    static let Settings = "Settings"
    
    static let Okay = "Okay"
    static let Cancel = "Cancel"
    
    static let Welcome_Name = "Welcome_XX1"
    
    static let Please_Verify_OTP = "Please_Verify_OTP"
    static let Verify_OTP = "Verify_OTP"
    static let Enter_OTP = "Enter_OTP"
    
}
