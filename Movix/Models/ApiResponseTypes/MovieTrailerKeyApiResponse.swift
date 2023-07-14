//
//  MovieTrailerKeyApiResponse.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 13.07.2023.
//

import Foundation

struct MovieTrailerKeyApiResponse: Codable{
    let id: Int?
    let results: [MovieTrailerKey]
}
