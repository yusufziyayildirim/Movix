//
//  MovieActionButtonViewModel.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 14.07.2023.
//

import UIKit

class MovieActionButtonViewModel {
    let movie: Movie
    let status: MovieStatus
    let imageName: String
    
    init(movie: Movie, status: MovieStatus, imageName: String) {
        self.movie = movie
        self.status = status
        self.imageName = imageName
    }
    
    var isMovieInStatus: Bool {
        do {
            let movies = try CoreDataManager.shared.fetchMovies(withStatus: status)
            return movies.contains { $0.id == movie.id }
        } catch {
            print("Failed to fetch movies with status \(status.rawValue): \(error)")
            return false
        }
    }
    
    var buttonTitle: String {
        return isMovieInStatus ? "Remove from \(status.rawValue)" : "Add to \(status.rawValue)"
    }
    
    var buttonImage: UIImage? {
        return isMovieInStatus ? UIImage(systemName: "\(imageName).fill") : UIImage(systemName: imageName)
    }
    
    func performAction() {
        do {
            if isMovieInStatus {
                try CoreDataManager.shared.removeMovie(movie: movie, status: status)
            } else {
                try CoreDataManager.shared.addMovie(movie: movie, status: status)
            }
        } catch {
            print("Failed to perform action for movie \(movie.title ?? "") in \(status.rawValue): \(error)")
        }
    }
}
