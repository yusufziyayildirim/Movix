//
//  MovieService.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 10.07.2023.
//

import Foundation

class MovieService: MovieServiceProtocol{
    
    let manager: NetworkManager? = DependencyContainer.shared.resolve()
    
    func getMovies(url: String, page: Int, completion: @escaping ((MovieApiResponse?) -> ())){
        let queryParams = ["api_key" : ApiRoutes.tmdbApiKey, "page" : String(page)]
        let getMoviesRequest = ApiRequest(url: url, method: .GET, headers: nil, queryParams: queryParams, body: nil)
        
        manager?.request(getMoviesRequest) { (result: Result<MovieApiResponse, Error>) in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getMovieDetail(id: Int, completion: @escaping ((Movie?) -> ())) {
        let queryParams = ["api_key" : ApiRoutes.tmdbApiKey]
        let getMovieDetailRequest = ApiRequest(url: ApiRoutes.movieDetail(id: id), method: .GET, headers: nil, queryParams: queryParams, body: nil)
        
        manager?.request(getMovieDetailRequest, completion: { (result: Result<Movie, Error>) in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getMovieVideoId(id: Int, completion: @escaping ((MovieTrailerKey?) -> ())) {
        let queryParams = ["api_key" : ApiRoutes.tmdbApiKey]
        let getMovieVideoIdRequest = ApiRequest(url: ApiRoutes.getMovieVideoId(id: id), method: .GET, headers: nil, queryParams: queryParams, body: nil)
        
        manager?.request(getMovieVideoIdRequest, completion: { ( result: Result<MovieTrailerKeyApiResponse, Error>) in
            switch result {
            case .success(let data):
                var trailer = data.results.first { trailer in
                    trailer.type == "Teaser"
                }
                
                if trailer == nil {
                    trailer = data.results.first { trailer in
                        trailer.type == "Trailer"
                    }
                }
                
                completion(trailer)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func searchMovie(query: String, page: Int, completion: @escaping ((MovieApiResponse?) -> ())) {
        let queryParams = ["api_key" : ApiRoutes.tmdbApiKey, "query": query, "page": String(page), "include_adult": "false"]
        
        let searchMovieRequest = ApiRequest(url: ApiRoutes.searchMovie, method: .GET, headers: nil, queryParams: queryParams, body: nil)
        
        manager?.request(searchMovieRequest, completion: { (result: Result<MovieApiResponse, Error>) in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error)
            }
        })
        
    }
    
    func getMovieComments(id: Int, completion: @escaping (([MovieComment]?) -> ())) {
        guard let token = UserSessionManager.shared.getBearerToken() else { return }
        
        let getMovieCommentsRequest = ApiRequest(url: ApiRoutes.getMovieComments(id: id), method: .GET, headers: ["Authorization": "Bearer \(token)"], queryParams: nil, body: nil)
        
        manager?.request(getMovieCommentsRequest) { (result: Result<LaravelApiResponse<[MovieComment]>, Error>) in
            switch result {
            case .success(let response):
                completion(response.data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addMovieComment(id: Int, comment: String, completion: @escaping (Result<LaravelApiResponse<MovieComment>, Error>) -> ()) {
        guard let token = UserSessionManager.shared.getBearerToken() else { return }
        
        let getMovieCommentsRequest = ApiRequest(url: ApiRoutes.addMovieComment, method: .POST, headers: ["Authorization": "Bearer \(token)"], queryParams: ["movie_id": id, "comment": comment], body: nil)
        
        manager?.request(getMovieCommentsRequest) { (result: Result<LaravelApiResponse<MovieComment>, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
