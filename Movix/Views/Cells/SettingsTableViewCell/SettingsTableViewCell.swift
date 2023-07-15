//
//  SettingsTableViewCell.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 15.07.2023.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconBgView: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var rightIcon: UIImageView!
    
    public let id = "settingsTableViewCell"
    public let nib = UINib(nibName: "SettingsTableViewCell", bundle: nil)

    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconBgView.layer.cornerRadius = 5
        iconBgView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
