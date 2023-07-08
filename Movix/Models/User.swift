//
//  User.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 8.07.2023.
//

import Foundation

struct User: Codable{
    let id: Int?
    let name: String?
    let email: String?
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, email
        case imageUrl = "img"
    }
}
