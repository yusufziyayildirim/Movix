//
//  DiscoverViewModel.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 10.07.2023.
//

import Foundation

class DiscoverViewModel: ObservableObject{
    
    let service: MovieServiceProtocol?
    
    @Published var fetchedMovies: [Movie] = []
    @Published var removedMovies = [Movie]()
    private var page = Int.random(in: 1..<300)
    var shouldDownloadMore: Bool = true
    
    init(service: MovieServiceProtocol){
        self.service = service
    }
    
    func getIndex(movie: Movie) -> Int{
        return fetchedMovies.firstIndex(where: { currentMovie in
            return movie.id == currentMovie.id
        }) ?? 0
    }
    
    func getDiscoverMovies() {
        service?.getMovies(url: ApiRoutes.discoverMovies(), page: page, completion: { [weak self] result in
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
    
}
