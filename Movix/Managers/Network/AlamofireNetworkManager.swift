//
//  AlamofireNetworkManager.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 8.07.2023.
//

import Foundation

final class AlamofireNetworkManager: NetworkManager {
    
    static let shared = AlamofireNetworkManager()
    
    private init() {}
    
    func request<T: Codable>(_ api: ApiRequest, completion: @escaping (Result<T, Error>) -> ()) {
        
        /*
            AF.request(url, method: api.method.rawValue, parameters: api.queryParams, encoding: URLEncoding.default,
                       headers: api.headers, interceptor: nil, requestModifier: nil)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    // Handle the success case and parse the response data
                    print("Response: \(value)")
                case .failure(let error):
                    // Handle any errors that occurred during the request
                    print("Error: \(error)")
                }
            }
        */
        
    }
    
}
