//
//  AuthService.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 8.07.2023.
//

import Foundation

class AuthService: AuthServiceProtocol {
    
    let manager: NetworkManager? = DependencyContainer.shared.resolve()
    
    
    func signUp(name: String, email: String, password: String, passwordConfrim: String, completion: @escaping (Result<LaravelApiResponse<String>, Error>) -> ()) {
        let queryParams = ["name" : name, "email" : email, "password": password, "password_confirmation": passwordConfrim]
        
        let signUpRequest = ApiRequest(url: ApiRoutes.signUp(), method: .POST, headers: nil, queryParams: queryParams, body: nil)
        manager?.request(signUpRequest) { (result: Result<LaravelApiResponse<String>, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(_):
                completion(.failure(AppError.custom("signUpError")))
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<LaravelApiResponse<String>, Error>) -> ()) {
        let queryParams = ["email" : email, "password": password]
        
        let signInRequest = ApiRequest(url: ApiRoutes.signIn(), method: .POST, headers: nil, queryParams: queryParams, body: nil)
        manager?.request(signInRequest) { (result: Result<LaravelApiResponse<String>, Error>) in
            switch result {
            case .success(let response):
                try? TokenManager.shared.saveBearerTokenToKeychain(token: response.data ?? "")
                self.isTokenValid(token: response.data ?? "") { _ in
                    completion(.success(response))
                }
            case .failure(_):
                completion(.failure(AppError.custom("signInError")))
            }
        }
    }
    
    func signOut(completion: @escaping (Bool) -> ()) {
        let logoutRequest = ApiRequest(url: ApiRoutes.signOut(), method: .POST, headers: ["Authorization" : "Bearer \(String(describing: UserSessionManager.shared.getBearerToken()))"], queryParams: nil, body: nil)
        manager?.request(logoutRequest) { (result: Result<LaravelApiResponse<User>, Error>) in
            switch result {
            case .success(_):
                try? TokenManager.shared.deleteBearerTokenFromKeychain()
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    func isTokenValid(token: String, completion: @escaping (Bool) -> ()) {
        let loggedUserRequest = ApiRequest(url: ApiRoutes.isTokenValid(), method: .GET, headers: ["Authorization" : "Bearer \(token)"], queryParams: nil, body: nil)
        
        manager?.request(loggedUserRequest) { (result: Result<LaravelApiResponse<[User]>, Error>) in
            switch result {
            case .success(let response):
                if let user = response.data?.first{
                    UserSessionManager.shared.setAllData(token: token, userName: user.name, userEmail: user.email, userImageUrl: user.imageUrl)
                }
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    
    func forgotPassword(email: String, completion: @escaping (Result<LaravelApiResponse<String>, Error>) -> ()) {
        let forgotPasswordRequest = ApiRequest(url: ApiRoutes.forgotPassword(), method: .POST, headers: nil, queryParams: ["email": email], body: nil)
        
        manager?.request(forgotPasswordRequest) { (result: Result<LaravelApiResponse<String>, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func resendVerifyEmail(email: String, completion: @escaping (Result<LaravelApiResponse<String>, Error>) -> ()) {
        let forgotPasswordRequest = ApiRequest(url: ApiRoutes.resendVerifyEmail(), method: .POST, headers: nil, queryParams: ["email": email], body: nil)
        
        manager?.request(forgotPasswordRequest) { (result: Result<LaravelApiResponse<String>, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
