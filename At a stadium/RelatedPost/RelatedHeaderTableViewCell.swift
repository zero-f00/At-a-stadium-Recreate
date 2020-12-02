//
//  RelatedHeaderTableViewCell.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/11/26.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import UIKit
import FirebaseUI

class RelatedHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var relatedCategorySectionLabel: UILabel!
    @IBOutlet weak var relatedHomeTeamLabel: UILabel!
    @IBOutlet weak var relatedAwayTeamLabel: UILabel!
    @IBOutlet weak var relatedStadiumLabel: UILabel!
    @IBOutlet weak var relatedStadiumImageView: UIImageView!
    @IBOutlet weak var relatedDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setMatchInfo(_ matchInfo: MatchData) {
        // カテゴリとセクションの表示
        self.relatedCategorySectionLabel.text = "\(matchInfo.category!) \(matchInfo.section!)"
        
        // ホームチームの表示
        self.relatedHomeTeamLabel.text = matchInfo.homeTeam!
        
        // アウェイチームの表示
        self.relatedAwayTeamLabel.text = matchInfo.awayTeam!
        
        // KICKOFFの表示
        self.relatedDateLabel.text = ""
        if let date = matchInfo.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateAndTime = date.formattedDateWith(style: .longDateAndTime)
            self.relatedDateLabel.text = "KICKOFF - \(dateAndTime)"
        }
        
        // スタジアム画像の表示
        relatedStadiumImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.stadiumImagePath).child(matchInfo.id + ".jpg")
        relatedStadiumImageView.sd_setImage(with: imageRef)
        
    }
    
}
