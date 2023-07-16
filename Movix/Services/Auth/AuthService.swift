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
    
    func changePassword(oldPassword: String, newPassword: String, newPasswordConfirm: String, completion: @escaping (Result<LaravelApiResponse<String>, Error>) -> ()) {
        let queryParams = ["password" : oldPassword, "new_password" : newPassword, "new_password_confirmation": newPasswordConfirm]
        guard let token = UserSessionManager.shared.getBearerToken() else { return }
        let headers = ["Authorization" : "Bearer \(token)"]
        
        let changePasswordRequest = ApiRequest(url: ApiRoutes.changePassword(), method: .POST, headers: headers, queryParams: queryParams, body: nil)
        manager?.request(changePasswordRequest) { (result: Result<LaravelApiResponse<String>, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(_):
                completion(.failure(AppError.custom("changePasswordError")))
            }
        }
    }
    
    func editProfile(name: String, image: Data?, completion: @escaping (Result<LaravelApiResponse<User>, Error>) -> ()) {
        
        guard let token = UserSessionManager.shared.getBearerToken() else { return }
        var headers = ["Authorization": "Bearer \(token)"]
        var bodyData = Data()
        
        if let imageData = image {
            let boundary = "Boundary-\(UUID().uuidString)"
            let boundaryPrefix = "--\(boundary)\r\n"
            let boundarySuffix = "--\(boundary)--\r\n"
            
            bodyData.append(Data(boundaryPrefix.utf8))
            bodyData.append(Data("Content-Disposition: form-data; name=\"img\"; filename=\"image.jpg\"\r\n".utf8))
            bodyData.append(Data("Content-Type: image/jpeg\r\n\r\n".utf8))
            bodyData.append(imageData)
            bodyData.append(Data("\r\n".utf8))
            bodyData.append(Data(boundarySuffix.utf8))
            
            headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        }
        
        
        let editProfileRequest = ApiRequest(url: ApiRoutes.editProfile(), method: .POST, headers: headers, queryParams: ["name" : name], body: bodyData)
        manager?.request(editProfileRequest) { (result: Result<LaravelApiResponse<User>, Error>) in
            switch result {
            case .success(let response):
                UserSessionManager.shared.setNameAndImg(userName: name, userImageUrl: response.data?.imageUrl)
                completion(.success(response))
            case .failure(_):
                completion(.failure(AppError.custom("changePasswordError")))
            }
        }
    }
    
}
