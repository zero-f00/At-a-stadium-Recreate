//
//  CommentTableViewCell.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/08/20.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import UIKit
import FirebaseUI

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var comment: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCommentPostData(_ postData: PostData) {
        
        var comments = ""
        
        // コメントしたユーザ名とコメント内容を表示
        for commnet in postData.commentText {
            comments += "\(commnet)"
        }
        comment.text = comments
        
    }
    
}
