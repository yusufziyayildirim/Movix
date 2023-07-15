//
//  SearchViewModel.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 14.07.2023.
//

import Foundation

class SearchViewModel {
    let service: MovieServiceProtocol
    weak var delegate: SearchViewModelDelegate?
    
    var movies: Observable<[Movie]> = Observable([])
    var searchHistoryMovies = [Movie]()
    var searchResult = true
    
    init(service: MovieServiceProtocol) {
        self.service = service
    }
    
    func searchMovie(query: String){
        service.searchMovie(query: query, page: 1, completion: { [weak self]  result in
            guard let self = self else { return }
            guard let returnedMovies = result else { return }
            
            if returnedMovies.results?.isEmpty == true {
                searchResult = false
            } else {
                searchResult = true
                movies.value = returnedMovies.results
            }
            
            delegate?.reloadTableView()
        })
    }
    
    func getSearchHistory() {
        do {
            let movies = try CoreDataManager.shared.fetchMovies(withStatus: .searchHistory)
            searchHistoryMovies += movies
            delegate?.reloadTableView()
        } catch {
            print("Failed to fetch movies with status search history: \(error)")
        }
    }
    
    func addSearcHistory(with movie: Movie) {
        if let index = searchHistoryMovies.firstIndex(where: { $0.id == movie.id }){
            deleteSearchHistoryMovie(with: index)
        }
        
        do {
            try CoreDataManager.shared.addMovie(movie: movie, status: .searchHistory)
            searchHistoryMovies.insert(movie, at: 0)
            delegate?.reloadTableView()
        } catch {
            print("Failed to fetch movies with status search history: \(error)")
        }
       
    }
    
    func deleteSearchHistoryMovie(with row: Int) {
        do {
            try CoreDataManager.shared.removeMovie(movie: searchHistoryMovies[row], status: .searchHistory)
            searchHistoryMovies.remove(at: row)
            delegate?.reloadTableView()
        } catch {
            print("Failed to fetch movies with status search history: \(error)")
        }
    }
    
    
    func clearSearchHistory() {
        do {
            try CoreDataManager.shared.removeAllMovies(status: .searchHistory)
            searchHistoryMovies = []
            delegate?.reloadTableView()
        } catch {
            print("Failed to fetch movies with status search history: \(error)")
        } 
    }
    
}
