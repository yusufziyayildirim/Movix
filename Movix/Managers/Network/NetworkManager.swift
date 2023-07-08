//
//  NetworkManager.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 8.07.2023.
//

import Foundation

protocol NetworkManager {
    func request<T: Codable>(_ api: ApiRequest, completion: @escaping (_ result: Result<T, Error>) -> Void)
}
