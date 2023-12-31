//
//  HomeViewModel.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 10.07.2023.
//

import Foundation

final class HomeViewModel{
    
    // MARK: - Service
    let service: MovieServiceProtocol?
    
    // MARK: - Delegate
    weak var delegate: HomeViewModelDelegate?
    
    // MARK: - Properties
    var isLoadingData: Observable<Bool> = Observable(false)
    var headerPosters: Observable<[Movie]> = Observable(nil)
    
    var sectionList: [(title: String, movies: [Movie], url: String)] = [
        ("Now Playing", [Movie](), ApiRoutes.nowPlayingMovies),
        ("Popular", [Movie](), ApiRoutes.popularMovies),
        ("Top Rated", [Movie](), ApiRoutes.topRatedMovies),
        ("Trending Movies", [Movie](), ApiRoutes.trendingMovies),
        ("Upcoming Movies", [Movie](), ApiRoutes.upcomingMovies)
    ]
    
    // MARK: - Initialization
    init(service: MovieServiceProtocol) {
        self.service = service
    }
    
    // MARK: - Private Methods
    private func getHeaderPosters(index: Int){
        let randomInt = Int.random(in: 1..<20)
        let movie = sectionList[index].movies[randomInt]
        
        if var posters = self.headerPosters.value {
            posters.append(movie)
            self.headerPosters.value = posters
        } else {
            self.headerPosters.value = [movie]
        }
    }
    
    // MARK: - Public Methods
    func getMovies(){
        for index in 0..<sectionList.count {
            let section = sectionList[index]
            
            service?.getMovies(url: section.url, page: 1, completion: { [weak self] result in
                guard let self = self else { return }
                guard let returnedMovies = result else { return }
                
                self.sectionList[index].movies.append(contentsOf: returnedMovies.results ?? [])
                delegate?.reloadTableView()
                getHeaderPosters(index: index)
            })
        }
    }
}
