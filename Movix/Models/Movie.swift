//
//  Movie.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 9.07.2023.
//

import Foundation

struct Movie: Codable, Identifiable {
    let id: Int?
    let overview, posterPath, releaseDate, title: String?
    let voteAverage: Double?
    let runtime: Int?
    let genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, genres
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}
