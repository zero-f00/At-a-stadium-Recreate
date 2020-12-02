//
//  MyPageHeaderTableViewCell.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/11/10.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import UIKit

class MyPageHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var selfIntroduction: UILabel!
    @IBOutlet weak var favoriteTeam: UILabel!
    @IBOutlet weak var SettingsButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //    func setProfile() {
    //        self.displayName.text = "テストユーザー"
    //        self.
    //    }
    
}
