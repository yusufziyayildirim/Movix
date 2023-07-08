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
        self.userName = userName
        self.userEmail = userEmail
        if let imageUrl = userImageUrl{
            guard let url = URL(string: imageUrl) else {
                return
            }
            self.userImageUrl = url
        }
    }
    
    func setNameAndImg(userName: String?,  userImageUrl: String?){
        self.userName = userName
        if let imageUrl = userImageUrl{
            guard let url = URL(string: imageUrl) else {
                return
            }
            self.userImageUrl = url
        }
    }
    
    func getUsername() -> String? {
        return userName
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
