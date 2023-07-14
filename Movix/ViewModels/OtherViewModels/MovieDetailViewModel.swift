//
//  MovieDetailViewModel.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 12.07.2023.
//

import Foundation

class MovieDetailViewModel{
    let service: MovieServiceProtocol?
    weak var delegate: MovieDetailViewModelDelegate?
    
    var movie: Movie?
    var videoKey: String?
    var sectionList = [(title: String, movies: [Movie], url: String)]()
    
    init(service: MovieServiceProtocol) {
        self.service = service
    }
    
    func getMovieDetail(id: Int){
        self.sectionList = [
            ("Similar Movies", [Movie](), ApiRoutes.similarMovies(id: id)),
            ("Recommendations", [Movie](), ApiRoutes.recommendations(id: id))
        ]
        
        service?.getMovieDetail(id: id, completion: {  [weak self] result in
            guard let self = self else { return }
            guard let movie = result else { return }
            
            self.movie = movie
            delegate?.setData()
        })
        
        getRecommendMovies()
        delegate?.changeLoadingViewState(isHidden: true)
        getMovieVideoId(id: id)
    }
    
    private func getRecommendMovies(){
        var count = 0
        let group = DispatchGroup()
        
        for index in 0..<sectionList.count {
            let section = sectionList[index]
            
            group.enter()
            
            service?.getMovies(url: section.url, page: 1, completion: { [weak self] result in
                guard let self = self else { return }
                guard let returnedMovies = result else { return }
                
                self.sectionList[index].movies.append(contentsOf: returnedMovies.results ?? [])
                
                if !sectionList[index].movies.isEmpty {
                    count += 1
                }
                
                group.leave()
            })
        }
        
        group.notify(queue: .main) {
            self.delegate?.changeTableViewHeight(with: count)
        }
        
    }
    
    private func getMovieVideoId(id: Int){
        service?.getMovieVideoId(id: id, completion: {  [weak self] result in
            guard let self = self else { return }
            guard let video = result else {
                delegate?.hidePlayButton()
                return
            }
            self.videoKey = video.key
        })
        
    }
}
