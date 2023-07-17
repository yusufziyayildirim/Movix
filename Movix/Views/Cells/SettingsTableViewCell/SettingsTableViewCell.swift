//
//  SettingsTableViewCell.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 15.07.2023.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var iconBgView: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var rightIcon: UIImageView!
    
    // MARK: - Cell Identifier and Nib
    public let id = "settingsTableViewCell"
    public let nib = UINib(nibName: "SettingsTableViewCell", bundle: nil)

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
        iconBgView.layer.cornerRadius = 5
        iconBgView.clipsToBounds = true
    }
    
}
