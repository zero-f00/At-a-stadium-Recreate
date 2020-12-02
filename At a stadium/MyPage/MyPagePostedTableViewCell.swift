//
//  MyPagePostedTableViewCell.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/06/04.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import UIKit
import FirebaseUI

class MyPagePostedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    
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
        
        let view = UIView()
        view.frame = CGRect(x : 10, y : 0, width : 375, height : 245)
        
        // 枠線の色
        view.layer.borderColor = UIColor.red.cgColor
        // 枠線の太さ
        view.layer.borderWidth = 3
        // 角丸
        view.layer.cornerRadius = 5
        // 角丸にした部分のはみ出し許可 false:はみ出し可 true:はみ出し不可
        view.layer.masksToBounds = true
        self.addMatchInfoView.addSubview(view)
    }
    
    // PostDataの内容をセルに表示
    func setMyPostData(_ postData: PostData) {
        
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
        
        //self.matchInfoCategory.text = postData.matchInfo.category
        
    }
    
}
