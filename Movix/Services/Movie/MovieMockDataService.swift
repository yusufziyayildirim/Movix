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
    
    func getMovieDetail(id: Int, completion: @escaping ((Movie?) -> ())) {
        //Mock Movie detial
    }
    
    func getMovieVideoId(id: Int, completion: @escaping ((MovieTrailerKey?) -> ())){
        //Mock video ID
    }
    
    func searchMovie(query: String, page: Int, completion: @escaping ((MovieApiResponse?) -> ())) {
        //Mock search movie
    }
    
    func getMovieComments(id: Int, completion: @escaping (([MovieComment]?) -> ())) {
        //Mock movie comments
    }
    
    func addMovieComment(id: Int, comment: String, completion: @escaping (Result<LaravelApiResponse<MovieComment>, Error>) -> ()) {
        //Mock add moive comment
    }

    
}

