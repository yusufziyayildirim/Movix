//
//  MovieServiceProtocol.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 10.07.2023.
//

import Foundation

protocol MovieServiceProtocol{
    func getMovies(url: String, page: Int, completion: @escaping ((MovieApiResponse?) -> ()))
    func getMovieDetail(id: Int, completion: @escaping ((Movie?) -> ()))
    func getMovieVideoId(id: Int, completion: @escaping ((MovieTrailerKey?) -> ()))
    func searchMovie(query: String, page: Int, completion: @escaping ((MovieApiResponse?) -> ()))
    func getMovieComments(id: Int, completion: @escaping (([MovieComment]?) -> ()))
    func addMovieComment(id: Int, comment: String, completion: @escaping (Result<LaravelApiResponse<MovieComment>, Error>) -> ())
}
