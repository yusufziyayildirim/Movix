//
//  MovieTableViewCell.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 10.07.2023.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var runtime: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var voteAverage: UILabel!
    @IBOutlet weak var firstStar: UIImageView!
    @IBOutlet weak var secondStar: UIImageView!
    @IBOutlet weak var thirdStar: UIImageView!
    @IBOutlet weak var fourthStar: UIImageView!
    @IBOutlet weak var fifthStar: UIImageView!
    
    // MARK: - Cell Identifier and Nib
    public let id = "movieTableViewCell"
    public let nib = UINib(nibName: "MovieTableViewCell", bundle: nil)
    
    // MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Private Methods
    private func configureUI() {
        movieImg.layer.cornerRadius = 15
    }

    /**
     Sets the color of the star icons based on the vote average value.
     
     - Parameter voteAverage: The vote average value of the movie.
     */
    private func setStarsColor(with voteAverage: Double) {
        
        if voteAverage >= 8 {
            firstStar.tintColor = .systemOrange
            secondStar.tintColor = .systemOrange
            thirdStar.tintColor = .systemOrange
            fourthStar.tintColor = .systemOrange
            fifthStar.tintColor = .systemOrange
        } else if voteAverage >= 6 {
            firstStar.tintColor = .systemOrange
            secondStar.tintColor = .systemOrange
            thirdStar.tintColor = .systemOrange
            fourthStar.tintColor = .systemOrange
            fifthStar.tintColor = .systemGray2
        } else if voteAverage >= 4 {
            firstStar.tintColor = .systemOrange
            secondStar.tintColor = .systemOrange
            thirdStar.tintColor = .systemOrange
            fourthStar.tintColor = .systemGray2
            fifthStar.tintColor = .systemGray2
        } else if voteAverage >= 2{
            firstStar.tintColor = .systemOrange
            secondStar.tintColor = .systemOrange
            thirdStar.tintColor = .systemGray2
            fourthStar.tintColor = .systemGray2
            fifthStar.tintColor = .systemGray2
        } else {
            firstStar.tintColor = .systemOrange
            secondStar.tintColor = .systemGray2
            thirdStar.tintColor = .systemGray2
            fourthStar.tintColor = .systemGray2
            fifthStar.tintColor = .systemGray2
        }
    }

    
    // MARK: - Public Methods
    
    /**
     Sets the data for the movie table view cell.
     
     - Parameter movie: The movie object containing the data.
     */
    public func setData(with movie: Movie) {
        self.movieTitle.text = movie.title
        self.movieImg.sd_setImage(with: URL(string: ApiRoutes.imageURL(posterPath: movie.posterPath ?? "")), placeholderImage: UIImage(named: "mainImg"))
        self.runtime.text = movie.runtime != nil ? String(movie.runtime!) : "N/A"
        
        if let releaseDate = movie.releaseDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: releaseDate) {
                let formattedDateFormatter = DateFormatter()
                formattedDateFormatter.dateFormat = "MM/dd/yyyy"
                let formattedDate = formattedDateFormatter.string(from: date)
                self.releaseDate.text = formattedDate
            } else {
                self.releaseDate.text = "N/A"
            }
        } else {
            self.releaseDate.text = "N/A"
        }
        
        let voteAverage = movie.voteAverage ?? 0
        self.voteAverage.text = String(format: "%.1f", voteAverage)
        
        setStarsColor(with: voteAverage)
    }
}
