//
//  MovieApiResponse.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 10.07.2023.
//

import Foundation

struct MovieApiResponse: Codable {
    let page: Int?
    let totalPages: Int?
    let results: [Movie]?
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
    }
}
