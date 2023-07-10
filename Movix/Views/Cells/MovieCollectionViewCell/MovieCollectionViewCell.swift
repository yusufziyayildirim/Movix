//
//  MovieCollectionViewCell.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 10.07.2023.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var voteAverage: UILabel!
    
    //Vote average starts
    @IBOutlet weak var firstStar: UIImageView!
    @IBOutlet weak var secondStar: UIImageView!
    @IBOutlet weak var thirdStar: UIImageView!
    @IBOutlet weak var fourthStar: UIImageView!
    @IBOutlet weak var fifthStar: UIImageView!
    
    public let id = "movieCollectionViewCell"
    public let nib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
    }

    func configureUI() {
        bgView.layer.cornerRadius = 10
        movieImg.layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.movieTitle.text = ""
        self.movieImg.image = nil
        self.voteAverage.text = ""
    }
    
    public func setData(with movie: Movie) {
        self.movieTitle.text = movie.title
        self.movieImg.sd_setImage(with: URL(string: ApiRoutes.imageURL(posterPath: movie.posterPath ?? "")), placeholderImage: UIImage(named: "mainImg"))
        let voteAverage = movie.voteAverage ?? 0
        self.voteAverage.text = String(format: "%.1f", voteAverage)
        
        setStarsColor(with: voteAverage)
    }
    
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
}
