//
//  LaravelApiResonse.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 8.07.2023.
//

import Foundation

struct LaravelApiResponse<T: Codable>: Codable {
    let status: Bool?
    let message: String?
    let data: T?
}
