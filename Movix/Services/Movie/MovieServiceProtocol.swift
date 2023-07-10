//
//  MovieServiceProtocol.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 10.07.2023.
//

import Foundation

protocol MovieServiceProtocol{
    func getMovies(url: String, page: Int, completion: @escaping ((MovieApiResponse?) -> ()))
}
