//
//  ApiRoutes.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 8.07.2023.
//

import Foundation

enum ApiRoutes {
    
    private static var laravelBaseUrl = "https://movixapi.innovaticacode.com/api"
    
    //LARAVEL API URLs
    static func signUp() -> String {
        "\(laravelBaseUrl)/register"
    }
    
    static func signIn() -> String {
        "\(laravelBaseUrl)/login"
    }
    
    static func signOut() -> String {
        "\(laravelBaseUrl)/logout"
    }
    
    static func isTokenValid() -> String {
        "\(laravelBaseUrl)/loggeduser"
    }
    
    static func forgotPassword() -> String {
        "\(laravelBaseUrl)/send-reset-password-email"
    }
    
    static func resendVerifyEmail() -> String {
        "\(laravelBaseUrl)/email/verification-notification"
    }
}
