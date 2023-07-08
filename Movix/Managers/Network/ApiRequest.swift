//
//  ApiRequest.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 8.07.2023.
//

import Foundation

struct ApiRequest {
    let url: String
    let method: HTTPMethods
    let headers: [String: String]?
    let queryParams: [String: Any]?
    let body: Data?
}
