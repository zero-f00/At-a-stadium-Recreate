//
//  CommentVCPostTableViewCell.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/09/04.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import UIKit

class CommentVCPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCommentVCPostData(_ postData: PostData) {
        // 投稿者の表示
        self.displayName.text = "\(postData.name!)"
        
        // 投稿時の時間
        self.dateLabel.text = ""
        if let date = postData.date {
            self.dateLabel.text = date.toFuzzy()
        }
        
        // キャプションの表示
        self.captionLabel.text = "\(postData.caption!) "
    }
    
}
