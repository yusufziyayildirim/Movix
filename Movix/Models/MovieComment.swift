//
//  MovieComment.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 16.07.2023.
//

import Foundation

struct MovieComment: Codable{
    let id: Int?
    let movieId: Int?
    let user: User?
    let comment: String?
    let date: String?
    
    enum CodingKeys: String, CodingKey {
        case id, user, comment
        case movieId = "movie_id"
        case date = "created_at"
    }
}

