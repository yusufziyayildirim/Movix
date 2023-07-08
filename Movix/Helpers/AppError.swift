//
//  AppError.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 8.07.2023.
//

import Foundation

enum AppError: Error {
    case invalidURL
    case noHttpBody
    case httpFailure
    case decodingError
    case error(Error)
    case custom(String)
}
