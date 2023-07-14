//
//  ApiRoutes.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 8.07.2023.
//

import Foundation

enum ApiRoutes {
    
    private static let laravelBaseUrl = "https://movixapi.innovaticacode.com/api"
    private static let tmdbBaseUrl = "https://api.themoviedb.org"
    static let tmdbApiKey = "b02965feff84b8f3e6d7fb314f02919d"
     
    //LARAVEL API URLs
    static func signUp() -> String {
        "\(laravelBaseUrl)/register"
    }
    
    static func signIn() -> String {
        "\(laravelBaseUrl)/login"
    }
    
    static func signOut() -> String {
        "\(laravelBaseUrl)/logout"
    }
    
    static func isTokenValid() -> String {
        "\(laravelBaseUrl)/loggeduser"
    }
    
    static func forgotPassword() -> String {
        "\(laravelBaseUrl)/send-reset-password-email"
    }
    
    static func resendVerifyEmail() -> String {
        "\(laravelBaseUrl)/email/verification-notification"
    }
    
    //TMDB API URLs
    static func trendingMovies() -> String {
        "\(tmdbBaseUrl)/3/trending/movie/day"
    }
    
    static func nowPlayingMovies() -> String {
        "\(tmdbBaseUrl)/3/movie/now_playing"
    }
    
    static func popularMovies() -> String {
        "\(tmdbBaseUrl)/3/movie/popular"
    }
    
    static func topRatedMovies() -> String {
        "\(tmdbBaseUrl)/3/movie/top_rated"
    }
    
    static func upcomingMovies() -> String {
        "\(tmdbBaseUrl)/3/movie/upcoming"
    }
    
    static func discoverMovies() -> String {
        "\(tmdbBaseUrl)/3/discover/movie"
    }
    
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

    static func searchMovie() -> String {
        "\(tmdbBaseUrl)/3/search/movie"
    }

}
