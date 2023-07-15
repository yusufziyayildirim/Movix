//
//  HomeTableViewCell.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 9.07.2023.
//

import UIKit
import SDWebImage

protocol MovieCollectionTableViewCellDelegate: AnyObject {
    func seeAllButtonTapped(row: Int)
    func didSelectItem(movieId: Int)
}

class MovieCollectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableViewCellTitle: UILabel!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    weak var delegate: MovieCollectionTableViewCellDelegate?
    
    public let id = "movieCollectionTableViewCell"
    public let nib = UINib(nibName: "MovieCollectionTableViewCell", bundle: nil)
    
    private var movies = [Movie]()
    private let cell = MovieCollectionViewCell()
    
    var row = Int()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        movieCollectionView.showsHorizontalScrollIndicator = false
        movieCollectionView.register(cell.nib, forCellWithReuseIdentifier: cell.id)
    }
    
    @IBAction func seeAllBtnTapped(_ sender: Any) {
        delegate?.seeAllButtonTapped(row: row)
    }
    
    public func setData(with movies: [Movie]) {
        self.movies = movies
        movieCollectionView.reloadOnMainThread()
    }
}


//MARK CollectionView delegate and datasource
extension MovieCollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cell.id, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setData(with: movies[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItem(movieId: movies[indexPath.row].id ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let selectedMovie = self.movies[indexPath.row]
        
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: { () -> UIViewController? in
                let imagePreviewVC = ImagePreviewVC(posterPath: selectedMovie.posterPath ?? "")
                return imagePreviewVC
            }) { _ in
                
                let favoriteButtonViewModel = MovieActionButtonViewModel(movie: selectedMovie, status: .favoriteMovies, imageName: "star")
                let watchlistButtonViewModel = MovieActionButtonViewModel(movie: selectedMovie, status: .watchlist, imageName: "bookmark")
                let historyButtonViewModel = MovieActionButtonViewModel(movie: selectedMovie, status: .watchHistory, imageName: "checkmark.seal")

                let favoriteAction = UIAction(title: favoriteButtonViewModel.buttonTitle, image: favoriteButtonViewModel.buttonImage) { _ in
                    favoriteButtonViewModel.performAction()
                }

                let watchlistAction = UIAction(title: watchlistButtonViewModel.buttonTitle, image: watchlistButtonViewModel.buttonImage) { _ in
                    watchlistButtonViewModel.performAction()
                }

                let historyAction = UIAction(title: historyButtonViewModel.buttonTitle, image: historyButtonViewModel.buttonImage) { _ in
                    historyButtonViewModel.performAction()
                }

                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [favoriteAction, watchlistAction, historyAction])
                
            }
        return config
        
    }
}
