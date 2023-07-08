//
//  URLSessionNetworkManager.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 8.07.2023.
//

import Foundation

final class URLSessionNetworkManager: NetworkManager {
    
    static let shared = URLSessionNetworkManager()
    
    private let configuration: URLSessionConfiguration
    private let session: URLSession
    
    private init() {
        self.configuration = URLSessionConfiguration.default
        self.configuration.timeoutIntervalForRequest = 30.0
        self.configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        
        self.session = URLSession(configuration: self.configuration)
    }
    
    func request<T: Codable>(_ api: ApiRequest, completion: @escaping (Result<T, Error>) -> ()) {
        
        guard let _ = URL(string: api.url), let preparedUrl = prepareURL(api) else {
            return completion(.failure(AppError.invalidURL))
        }
        
        var urlRequest = URLRequest(url: preparedUrl)
        urlRequest.httpMethod = api.method.rawValue
        urlRequest.allHTTPHeaderFields = api.headers
        urlRequest.httpBody = api.body
        
        self.session.dataTask(with: urlRequest) { [weak self] data, response, error in
            
            guard let self = self else { return }
            
            // onFailure
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Validation
            guard (200...299).contains((response as? HTTPURLResponse)?.statusCode ?? 0) else {
                completion(.failure(AppError.httpFailure))
                return
            }
            
            // onSuccess
            if let data = data {
                // Transform Data to Codable Type
                self.handleData(data: data) { response in
                    completion(response)
                }
            } else {
                completion(.failure(AppError.noHttpBody))
            }
            
        }.resume()
    }
    
    
    private func prepareURL(_ api: ApiRequest) -> URL? {
        var urlComponents = URLComponents(string: api.url)
        let queryItems = api.queryParams?.map({ (key, value) in
            return URLQueryItem(name: key, value: String(describing: value) )
        })
        urlComponents?.queryItems = queryItems
        return urlComponents?.url
    }
    
    
    private func handleData<T: Codable>(data: Data, completion: @escaping(Result<T, Error>) -> ()) {
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            completion(.success(result))
            
        } catch {
            completion(.failure(AppError.decodingError))
        }
    }
}
