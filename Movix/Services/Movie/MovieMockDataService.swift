//
//  MovieMockDataService.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 10.07.2023.
//

import Foundation

class MovieMockDataService: MovieServiceProtocol{
        
    init() {}

    func getMovies(url: String, page: Int, completion: @escaping ((MovieApiResponse?) -> ())){
        //Mock Movie data
    }
    
}

