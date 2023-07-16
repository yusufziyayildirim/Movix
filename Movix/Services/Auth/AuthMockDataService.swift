//
//  AuthMockDataService.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 8.07.2023.
//

import Foundation

class AuthMockDataService: AuthServiceProtocol{
    
    func signUp(name: String, email: String, password: String, passwordConfrim: String, completion: @escaping (Result<LaravelApiResponse<String>, Error>) -> ()) {
        // Mock Sign Up
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<LaravelApiResponse<String>, Error>) -> ()) {
        // Mock Sign In
    }
    
    func signOut(completion: @escaping (Bool) -> ()) {
        // Mock Sign Out
    }
    
    func isTokenValid(token: String, completion: @escaping (Bool) -> ()) {
        // Mock Token Control
    }
    
    func forgotPassword(email: String, completion: @escaping (Result<LaravelApiResponse<String>, Error>) -> ()) {
        // Mock Forgot Password
    }
    
    func resendVerifyEmail(email: String, completion: @escaping (Result<LaravelApiResponse<String>, Error>) -> ()) {
        // Mock Resend Verify Email
    }
    
    func changePassword(oldPassword: String, newPassword password: String, newPasswordConfirm passwordConfrim: String, completion: @escaping (Result<LaravelApiResponse<String>, Error>) -> ()) {
        // Mock Change password
    }
    
    func editProfile(name: String, image: Data?, completion: @escaping (Result<LaravelApiResponse<User>, Error>) -> ()) {
        // Mock edit profile
    }
    
    
}
