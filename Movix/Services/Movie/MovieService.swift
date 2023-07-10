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
    
}
