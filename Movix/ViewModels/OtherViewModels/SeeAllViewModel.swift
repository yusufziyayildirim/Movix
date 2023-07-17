//
//  SeeAllViewModel.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 11.07.2023.
//

import Foundation

class SeeAllViewModel {
    
    // MARK: - Service
    let service: MovieServiceProtocol?
    
    // MARK: - Properties
    var movies: Observable<[Movie]> = Observable([])
    private var page = 1
    var shouldDownloadMore: Bool = true
    
    // MARK: - Initialization
    init(service: MovieServiceProtocol) {
        self.service = service
    }
    
    // MARK: - Public Methods
    func getMovies(url: String){
        service?.getMovies(url: url, page: page, completion: { [weak self]  result in
            guard let self = self else { return }
            guard let returnedMovies = result else { return }
            
            if var moviesData = self.movies.value {
                moviesData.append(contentsOf: returnedMovies.results ?? [])
                self.movies.value = moviesData
            } else {
                print("else \(page)")
            }
            
            if self.page >= 500 {
                shouldDownloadMore = false
            }
            
            self.page += 1
        })
    }
    
}
