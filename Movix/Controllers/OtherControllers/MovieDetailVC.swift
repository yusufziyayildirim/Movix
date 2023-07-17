//
//  MovieDetailVC.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 7.07.2023.
//

import UIKit
import SDWebImage
import YouTubeiOSPlayerHelper

protocol MovieDetailViewModelDelegate: AnyObject{
    func setData()
    func reloadTableView()
    func hidePlayButton()
    func changeLoadingViewState(isHidden: Bool)
    func changeTableViewHeight(with: Int)
}

class MovieDetailVC: UIViewController{
    
    // MARK: - Outlets
    @IBOutlet weak var movieTrailerView: UIView!
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var playButton: LoadingButton!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieImdb: UILabel!
    @IBOutlet weak var movieRuntime: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var movieRecommendsTable: UITableView!
    
    // MARK: - ViewModel
    let viewModel = MovieDetailViewModel(service: MovieService())
    
    // MARK: - Properties
    private let cell = MovieCollectionTableViewCell()
    var player: YTPlayerView!
    var loadingView: UIView?
    var activityIndicator: UIActivityIndicatorView?
    var movieId = Int()
    var menuButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "ellipsis"), primaryAction: nil, menu: nil)
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLoadingView()
        changeLoadingViewState(isHidden: false)
        configureUI()
        configureTableView()
        
        viewModel.delegate = self
        viewModel.getMovieDetail(id: movieId)
        
        navigationItem.rightBarButtonItem = menuButton
    }
    
    // MARK: - Actions
    @IBAction func playBtnTapped(_ sender: Any) {
        startVideo()
    }
    
    @IBAction func commentsBtnTapped(_ sender: Any) {
        navigateToMovieCommentsScreen(with: movieId)
    }
    
    // MARK: - Private Methods
    private func configureUI() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.5).cgColor, UIColor.black.withAlphaComponent(0.5).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = posterImg.bounds
        posterImg.layer.addSublayer(gradientLayer)
        
        movieOverview.translatesAutoresizingMaskIntoConstraints = false
        movieOverview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        movieOverview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
    }
    
    private func configureLoadingView() {
        loadingView = UIView(frame: view.bounds)
        loadingView?.backgroundColor = UIColor.systemBackground
        loadingView?.alpha = 1

        activityIndicator = UIActivityIndicatorView()
        activityIndicator?.center = loadingView?.center ?? CGPoint.zero
        activityIndicator?.startAnimating()

        if let loadingView = loadingView, let activityIndicator = activityIndicator {
            loadingView.addSubview(activityIndicator)
            view.addSubview(loadingView)
        }
    }
    
    private func configureTableView() {
        movieRecommendsTable.isScrollEnabled = false
        movieRecommendsTable.delegate = self
        movieRecommendsTable.dataSource = self
        movieRecommendsTable.register(cell.nib, forCellReuseIdentifier: cell.id)
        movieRecommendsTable.allowsSelection = false
        movieRecommendsTable.separatorStyle = .none
    }
    
    private func startVideo() {
        self.playButton.showLoading()
        self.playButton.setImage(nil, for: .normal)
        
        guard let videoID = viewModel.videoKey else {
            print("Invalid video ID")
            return
        }
        
        player = YTPlayerView()
        player.delegate = self
        player.frame.size = movieTrailerView.frame.size
        player.load(withVideoId: videoID, playerVars: ["playsinline" : 0, "fs" : 1])
    }
    
    private func navigateToSeeAllScreen(row: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "SeeAllVC") as! SeeAllVC
        destinationVC.url = viewModel.sectionList[row].url
        destinationVC.pageTitle = viewModel.sectionList[row].title
        navigationController?.pushViewController(destinationVC, animated: true)
        
    }
    
    private func navigateToDetailScreen(with id: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        destinationVC.movieId = id
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
    private func navigateToMovieCommentsScreen(with id: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "MovieCommentsVC") as! MovieCommentsVC
        destinationVC.movieId = id
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @discardableResult
    private func createMenu() -> UIMenu  {
        if let movie = viewModel.movie {
            let favoriteButtonViewModel = MovieActionButtonViewModel(movie: movie, status: .favoriteMovies, imageName: "star")
            let watchlistButtonViewModel = MovieActionButtonViewModel(movie: movie, status: .watchlist, imageName: "bookmark")
            let historyButtonViewModel = MovieActionButtonViewModel(movie: movie, status: .watchHistory, imageName: "checkmark.seal")
            
            let favoriteAction = UIAction(title: favoriteButtonViewModel.buttonTitle, image: favoriteButtonViewModel.buttonImage) { [weak self] _ in
                favoriteButtonViewModel.performAction()
                self?.updateMenu()
            }
            
            let watchlistAction = UIAction(title: watchlistButtonViewModel.buttonTitle, image: watchlistButtonViewModel.buttonImage) { [weak self] _ in
                watchlistButtonViewModel.performAction()
                self?.updateMenu()
            }
            
            let historyAction = UIAction(title: historyButtonViewModel.buttonTitle, image: historyButtonViewModel.buttonImage) { [weak self] _ in
                historyButtonViewModel.performAction()
                self?.updateMenu()
            }
            
            let menu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [favoriteAction, watchlistAction, historyAction])

            return menu
        }
        return UIMenu()
    }
    
    private func updateMenu() {
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItem?.menu = self.createMenu()
        }
    }
}

// MARK: - TableView Delegate and DataSource
extension MovieDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        for section in viewModel.sectionList {
            if !section.movies.isEmpty {
                count += 1
            }
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let homeTableViewCell = tableView.dequeueReusableCell(withIdentifier: cell.id, for: indexPath) as? MovieCollectionTableViewCell else {
            return UITableViewCell()
        }
        homeTableViewCell.delegate = self
        homeTableViewCell.row = indexPath.row
        homeTableViewCell.tableViewCellTitle.text = viewModel.sectionList[indexPath.row].title
        homeTableViewCell.setData(with: viewModel.sectionList[indexPath.row].movies)
        
        return homeTableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
}

// MARK: - MovieCollectionTableViewCell ViewModel Delegate
extension MovieDetailVC: MovieCollectionTableViewCellDelegate {
    func seeAllButtonTapped(row: Int) {
        navigateToSeeAllScreen(row: row)
    }
    
    func didSelectItem(movieId: Int) {
        navigateToDetailScreen(with: movieId)
    }
}

// MARK: - MovieDetail ViewModel Delegate
extension MovieDetailVC: MovieDetailViewModelDelegate {
    
    func reloadTableView() {
        movieRecommendsTable.reloadOnMainThread()
    }
    
    func setData(){
        DispatchQueue.main.async {
            
            self.posterImg.sd_setImage(with: URL(string: ApiRoutes.imageURL(posterPath: self.viewModel.movie?.posterPath ?? "")), placeholderImage: UIImage(named: "mainImg"))
            self.movieTitle.text = self.viewModel.movie?.title
            
            if let releaseDate = self.viewModel.movie?.releaseDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                if let date = dateFormatter.date(from: releaseDate) {
                    let yearFormatter = DateFormatter()
                    yearFormatter.dateFormat = "yyyy"
                    let yearString = yearFormatter.string(from: date)
                    self.movieYear.text = yearString
                } else {
                    self.movieYear.text = "N/A"
                }
            } else {
                self.movieYear.text = "N/A"
            }
            
            if let voteAverage = self.viewModel.movie?.voteAverage {
                self.movieImdb.text = String(format: "%.1f", voteAverage)
            } else {
                self.movieImdb.text = "N/A"
            }
            
            if let runtime = self.viewModel.movie?.runtime {
                self.movieRuntime.text = String(runtime)
            } else {
                self.movieRuntime.text = "N/A"
            }
            
            self.movieOverview.text = self.viewModel.movie?.overview
            
            if let genres = self.viewModel.movie?.genres {
                let genreNames = genres.compactMap { $0.name }
                let genresString = genreNames.joined(separator: ", ")
                self.movieGenre.text = genresString
            } else {
                self.movieGenre.text = "N/A"
            }
        }
    }
    
    func hidePlayButton() {
        DispatchQueue.main.async {
            self.playButton.isHidden = true
        }
    }
    
    func changeLoadingViewState(isHidden: Bool) {
        DispatchQueue.main.async {
            self.loadingView?.isHidden = isHidden
        }
        
        if isHidden {
            menuButton.menu = createMenu()
        }
    }
    
    func changeTableViewHeight(with count: Int){
        let tableViewHeight = CGFloat(300 * count)
        DispatchQueue.main.async {
            self.movieRecommendsTable.translatesAutoresizingMaskIntoConstraints = false
            let heightConstraint = self.movieRecommendsTable.heightAnchor.constraint(equalToConstant: tableViewHeight)
            heightConstraint.isActive = true
            self.view.layoutIfNeeded()
        }
        
        
        reloadTableView()
    }
}

// MARK: - YTPlayer ViewModel Delegate
extension MovieDetailVC: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playButton.hideLoading()
        movieTrailerView.addSubview(player)
        playerView.playVideo()
    }
}
