//
//  SavedMoviesViewModel.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 15.07.2023.
//

import Foundation

class SavedMoviesViewModel{
    
    // MARK: - Delegate
    weak var delegate: SavedMoviesViewModelDelegate?
    
    // MARK: - Properties
    var movies: [Movie] = []
    
    // MARK: - Public Methods
    func getSavedMovies(status: MovieStatus){
        do{
            let result = try CoreDataManager.shared.fetchMovies(withStatus: status)
            self.movies = result
            delegate?.reloadTableView()
        } catch {
            print(error)
        }
    }
    
    func removeMovie(with row: Int, status: MovieStatus) {
        do {
            try CoreDataManager.shared.removeMovie(movie: movies[row], status: status)
            movies.remove(at: row)
            print(movies.count)
            delegate?.reloadTableView()
        } catch {
            print("Failed to fetch movies with status search history: \(error)")
        }
    }
}
