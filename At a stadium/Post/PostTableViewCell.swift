//
//  PostTableViewCell.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/05/07.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import UIKit
import FirebaseUI

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!

    
    @IBOutlet weak var addMatchInfoButton: UIButton!
    @IBOutlet weak var addMatchInfoView: UIView!
    @IBOutlet weak var matchInfoCategory: UILabel!
    @IBOutlet weak var matchInfoDate: UILabel!
    @IBOutlet weak var matchInfoHomeT: UILabel!
    @IBOutlet weak var matchInfoAwayT: UILabel!
    @IBOutlet weak var matchInfoStadiumImageView: UIImageView!
    @IBOutlet weak var matchInfoStadiumLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        // 枠線の色
        addMatchInfoView.layer.borderColor = UIColor.red.cgColor
        // 枠線の太さ
        addMatchInfoView.layer.borderWidth = 3
        // 角丸
        addMatchInfoView.layer.cornerRadius = 5
        addMatchInfoView.layer.masksToBounds = true
    }
    
    // PostDataの内容をセルに表示
    func setPostData(_ postData: PostData) {
        
        // 投稿者の表示
        self.displayName.text = "\(postData.name!)"
        
        // 投稿時の時間
        self.dateLabel.text = ""
        if let date = postData.date {
            self.dateLabel.text = date.toFuzzy()
        }
        
        // キャプションの表示
        self.captionLabel.text = "\(postData.caption!) "
        
        // 画像の表示
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        postImageView.sd_setImage(with: imageRef)
        
        // いいねボタンの表示
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
        
    }
    
    
    // MatchDataの内容をaddMatchInfoViewに表示
    func setMatchData(_ matchData: MatchData) {
        // カテゴリーとセクションの表示
        self.matchInfoCategory.text = "\(matchData.category!) \(matchData.section!)"
        
        // キックオフの時間の表示
        self.matchInfoDate.text = ""
        if let date = matchData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateAndTime = date.formattedDateWith(style: .longDateAndTime)
            self.matchInfoDate.text = "KICKOFF - \(dateAndTime)"
        }

        // ホームチームの表示
        self.matchInfoHomeT.text = "\(matchData.homeTeam!)"

        // アウェイチームの表示
        self.matchInfoAwayT.text = "\(matchData.awayTeam!)"

        // スタジアム画像の表示
        matchInfoStadiumImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.stadiumImagePath).child(matchData.id + ".jpg")
        matchInfoStadiumImageView.sd_setImage(with: imageRef)
    }
    
    
    
}
