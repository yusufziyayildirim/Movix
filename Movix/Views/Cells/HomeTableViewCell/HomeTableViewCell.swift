//
//  HomeTableViewCell.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 9.07.2023.
//

import UIKit
import SDWebImage

protocol HomeTableViewCellDelegate: AnyObject {
    func seeAllButtonTapped(row: Int)
    func didSelectItem()
}

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableViewCellTitle: UILabel!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    weak var delegate: HomeTableViewCellDelegate?
    
    public let id = "homeTableViewCell"
    public let nib = UINib(nibName: "HomeTableViewCell", bundle: nil)
    
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
extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
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
        delegate?.didSelectItem()
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: { () -> UIViewController? in
                let imagePreviewVC = ImagePreviewViewController(posterPath: self.movies[indexPath.row].posterPath ?? "")
                return imagePreviewVC
            }) {[weak self] _ in
                
                let favoriteAction = UIAction(title: "Add favorite", image: UIImage(systemName: "star")) { _ in
                    guard let _ = self else {
                        return
                    }
                    //Tapped the button
                }
                
                let watchAction = UIAction(title: "Add watchlist", image: UIImage(systemName: "bookmark")) { _ in
                    guard let _ = self else {
                        return
                    }
                    //Tapped the button
                }
                
                let watchedAction = UIAction(title: "Add watchedlist", image: UIImage(systemName: "checkmark.seal")) { _ in
                    guard let _ = self else {
                        return
                    }
                    //Tapped the button
                }
                
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [favoriteAction, watchAction, watchedAction])
                
            }
        return config
        
    }
}


private class ImagePreviewViewController: UIViewController {
    
    private let imageView = UIImageView()
    private let posterPath: String?
    
    init(posterPath: String) {
        self.posterPath = posterPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.sd_setImage(with: URL(string: ApiRoutes.imageURL(posterPath: posterPath ?? "")), placeholderImage: UIImage(named: "mainImg"))
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        imageView.pinToEdgesOf(view: view)
    }
}
