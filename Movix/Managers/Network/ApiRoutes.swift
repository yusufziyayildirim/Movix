//
//  ApiRoutes.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 8.07.2023.
//

import Foundation

enum ApiRoutes {
    static let laravelBaseUrl = "https://movixapi.innovaticacode.com"
    private static let laravelBaseApiUrl = "\(laravelBaseUrl)/api"
    private static let tmdbBaseUrl = "https://api.themoviedb.org"
    static let tmdbApiKey = "b02965feff84b8f3e6d7fb314f02919d"
     
    //LARAVEL API URLs
    static let signUp = "\(laravelBaseApiUrl)/register"
    static let signIn = "\(laravelBaseApiUrl)/login"
    static let signOut =  "\(laravelBaseApiUrl)/logout"
    static let isTokenValid = "\(laravelBaseApiUrl)/loggeduser"
    static let forgotPassword = "\(laravelBaseApiUrl)/send-reset-password-email"
    static let resendVerifyEmail =  "\(laravelBaseApiUrl)/email/verification-notification"
    static let changePassword = "\(laravelBaseApiUrl)/update/password"
    static let editProfile =  "\(laravelBaseApiUrl)/update/profile"
    static let addMovieComment = "\(laravelBaseApiUrl)/movie/comment/add"
    
    static func getMovieComments(id: Int) -> String {
        "\(laravelBaseApiUrl)/movie/\(id)/comments"
    }
    
    //TMDB API URLs
    static let trendingMovies = "\(tmdbBaseUrl)/3/trending/movie/day"
    static let nowPlayingMovies = "\(tmdbBaseUrl)/3/movie/now_playing"
    static let popularMovies = "\(tmdbBaseUrl)/3/movie/popular"
    static let topRatedMovies = "\(tmdbBaseUrl)/3/movie/top_rated"
    static let upcomingMovies = "\(tmdbBaseUrl)/3/movie/upcoming"
    static let discoverMovies = "\(tmdbBaseUrl)/3/discover/movie"
    static let searchMovie = "\(tmdbBaseUrl)/3/search/movie"
    
    static func imageURL(posterPath: String) -> String {
        "https://image.tmdb.org/t/p/w500/\(posterPath)"
    }
    
    static func movieDetail(id: Int) -> String {
        "\(tmdbBaseUrl)/3/movie/\(id)"
    }
    
    static func similarMovies(id: Int) -> String {
        "\(tmdbBaseUrl)/3/movie/\(id)/similar"
    }
    
    static func recommendations(id: Int) -> String {
        "\(tmdbBaseUrl)/3/movie/\(id)/recommendations"
    }
    
    static func getMovieVideoId(id: Int) -> String {
        "\(tmdbBaseUrl)/3/movie/\(id)/videos"
    }

}
