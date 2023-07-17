//
//  MovieCommentsTableViewCell.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 16.07.2023.
//

import UIKit
import SDWebImage

class MovieCommentsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentDateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    // MARK: - Cell Identifier and Nib
    public let id = "movieCommentsTableViewCell"
    public let nib = UINib(nibName: "MovieCommentsTableViewCell", bundle: nil)
    
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
        userImg.layer.cornerRadius = userImg.bounds.width / 2
    }
    
    // MARK: - Public Methods

    /**
     Sets the data for the movie comment cell.
     
     - Parameter movieComment: The movie comment object containing the data.
     */
    public func setData(with movieComment: MovieComment) {
        // Set data to UI elements
        self.userNameLabel.text = movieComment.user?.name
        self.commentLabel.text = movieComment.comment
        
        if let imageUrl = movieComment.user?.imageUrl, let url = URL(string: ApiRoutes.laravelBaseUrl + "/storage/" + imageUrl) {
            self.userImg.sd_setImage(with: url)
        }
        
        if let releaseDate = movieComment.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            
            if let date = dateFormatter.date(from: releaseDate) {
                let formattedDateFormatter = DateFormatter()
                formattedDateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                
                let formattedDate = formattedDateFormatter.string(from: date)
                self.commentDateLabel.text = formattedDate
            } else {
                self.commentDateLabel.text = "N/A"
            }
        } else {
            self.commentDateLabel.text = "N/A"
        }
        
    }
}
