//
//  addMatchDataTableViewCell.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/05/12.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import UIKit
import FirebaseUI

class addMatchDataTableViewCell: UITableViewCell {

    @IBOutlet weak var categorySectionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var awayTeamLabel: UILabel!
    @IBOutlet weak var stadiumLabel: UILabel!
    @IBOutlet weak var stadiumImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        
    }
    
    // MatchDataの内容をセルに表示
    func setMatchData(_ matchData: MatchData) {
        
        // カテゴリの表示 セクションの表示
        self.categorySectionLabel.text = "\(matchData.category!) \(matchData.section!)"
        print("DEBUG_PRINT \(String(describing: self.categorySectionLabel.text))")
        
        // キックオフの時間の表示
        self.dateLabel.text = ""
        if let date = matchData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateAndTime = date.formattedDateWith(style: .longDateAndTime)
            self.dateLabel.text = "KICKOFF - \(dateAndTime)"
        }
        
        // 対戦カードの表示
        self.homeTeamLabel.text = "\(matchData.homeTeam!)"
        self.awayTeamLabel.text = "\(matchData.awayTeam!)"
        
        // スタジアム情報
        
        
        // スタジアム画像の表示
        stadiumImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.stadiumImagePath).child(matchData.id + ".jpg")
        stadiumImageView.sd_setImage(with: imageRef)
        print("DEBUG_PRINT \(imageRef)")
        
    }
    
}
