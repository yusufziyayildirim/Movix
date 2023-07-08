//
//  AuthServiceProtocol.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 8.07.2023.
//

import Foundation

protocol AuthServiceProtocol {
    func signUp(name: String, email: String, password: String, passwordConfrim: String, completion: @escaping (Result<LaravelApiResponse<String>, Error>) -> ())
    func signIn(email: String, password: String, completion: @escaping (Result<LaravelApiResponse<String>, Error>) -> ())
    func signOut(completion: @escaping (Bool) -> ())
    func isTokenValid(token: String, completion: @escaping (Bool) -> ())
    func forgotPassword(email: String, completion: @escaping (Result<LaravelApiResponse<String>, Error>) -> ())
    func resendVerifyEmail(email: String, completion: @escaping (Result<LaravelApiResponse<String>, Error>) -> ())
}
