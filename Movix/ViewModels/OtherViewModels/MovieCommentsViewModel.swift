//
//  MovieCommentsViewModel.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 16.07.2023.
//

import Foundation

class MovieCommentsViewModel{
    let service: MovieServiceProtocol?
    weak var delegate: MovieCommentsViewModelDelegate?
    
    var comments = [MovieComment]()
    
    init(service: MovieServiceProtocol) {
        self.service = service
    }
    
    func addComment(movieId: Int, comment: String) {
        service?.addMovieComment(id: movieId, comment: comment, completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if response.status ?? false {
                    if let comments = response.data{
                        self.comments.append(comments)
                        delegate?.reloadTableView()
                    }
                } else {
                    delegate?.showErrorAlert()
                }
            case .failure(_):
                delegate?.showErrorAlert()
            }
        })
    }
    
    func getMovieComments(movieId: Int) {
        delegate?.activityIndicatorStaus(status: true)
        service?.getMovieComments(id: movieId, completion: { [weak self] result in
            guard let self = self else { return }
            guard let returnedComments = result else { return }
            
            self.comments.append(contentsOf: returnedComments)
            self.delegate?.activityIndicatorStaus(status: false)
            self.delegate?.reloadTableView()
        })
    }
}
