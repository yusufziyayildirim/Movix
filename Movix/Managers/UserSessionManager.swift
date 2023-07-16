//
//  UserSessionManager.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 8.07.2023.
//

import UIKit

class UserSessionManager {
    static let shared = UserSessionManager()
    
    private var userName: String?
    private var userImageUrl: URL?
    private var userEmail: String?
    private var bearerToken: String?
    
    private init() {}
    
    func setAllData(token: String?, userName: String?, userEmail: String?, userImageUrl: String?){
        self.bearerToken = token
        self.userEmail = userEmail
        
        setNameAndImg(userName: userName, userImageUrl: userImageUrl)
    }
    
    func setNameAndImg(userName: String?,  userImageUrl: String?){
        self.userName = userName
        if let imageUrl = userImageUrl, !imageUrl.isEmpty{
            guard let url = URL(string: "\(ApiRoutes.laravelBaseUrl)/storage/\(imageUrl)") else {
                return
            }
            self.userImageUrl = url
        }
    }
    
    func getUsername() -> String? {
        guard let username = userName else {
            return nil
        }
        
        let components = username.components(separatedBy: " ")
        let capitalizedComponents = components.map { $0.capitalized }
        let capitalizedUsername = capitalizedComponents.joined(separator: " ")
        
        return capitalizedUsername
    }
    
    func getUserImageUrl() -> URL? {
        return userImageUrl
    }
    func getUserEmail() -> String? {
        return userEmail
    }
    
    func getBearerToken() -> String? {
        return bearerToken
    }
}
