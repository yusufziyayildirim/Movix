//
//  DiscoverViewModel.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 10.07.2023.
//

import Foundation

class DiscoverViewModel: ObservableObject{
    
    // MARK: - Service
    let service: MovieServiceProtocol?
    
    // MARK: - Delegate
    weak var delegate: DiscoverViewModelDelegate?
    
    // MARK: - Properties
    @Published var fetchedMovies: [Movie] = []
    @Published var removedMovies = [Movie]()
    private var page = Int.random(in: 1..<300)
    var shouldDownloadMore: Bool = true
    
    // MARK: - Initialization
    init(service: MovieServiceProtocol){
        self.service = service
        getDiscoverMovies()
    }
    
    // MARK: - Public Methods
    func getIndex(movie: Movie) -> Int{
        return fetchedMovies.firstIndex(where: { currentMovie in
            return movie.id == currentMovie.id
        }) ?? 0
    }
    
    func getDiscoverMovies() {
        service?.getMovies(url: ApiRoutes.discoverMovies, page: page, completion: { [weak self] result in
            guard let self = self else { return }
            guard let returnedMovies = result else { return }
            
            DispatchQueue.main.async {
                self.fetchedMovies.append(contentsOf: returnedMovies.results ?? [])
            }
            
            if self.page >= 500 {
                shouldDownloadMore = false
            }
            
            self.page += 1
        })
    }
    
    func navigateToDetailScreen(with id: Int){
        delegate?.navigateToDetailScreen(with: id)
    }
    
    func isMovieInStatus(status: MovieStatus) -> Bool {
        do {
            let movies = try CoreDataManager.shared.fetchMovies(withStatus: status)
            return movies.contains { $0.id == fetchedMovies[0].id }
            
        } catch {
            print("Failed to perform action: \(error)")
        }
        
        return false
    }

    func performAction(status: MovieStatus) {
        do {
            let isMovieInStatus = isMovieInStatus(status: status)
            
            if isMovieInStatus {
                try CoreDataManager.shared.removeMovie(movie: fetchedMovies[0], status: status)
            } else {
                try CoreDataManager.shared.addMovie(movie: fetchedMovies[0], status: status)
            }
        } catch {
            print("Failed to perform action for movie : \(error)")
        }
    }
    
}
