//
//  PostData.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/05/04.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import UIKit
import Firebase

class PostData: NSObject {
    var id: String
    var name: String?
    var caption: String?
    var date: Date?
    var matchInfoId: String?
    var likes: [String] = []
    var isLiked: Bool = false
    var commentText: [String] = []
    
    init(document: QueryDocumentSnapshot) {
        
        self.id = document.documentID
        
        let postDic = document.data()
        
        self.name = postDic["name"] as? String
        
        self.caption = postDic["caption"] as? String
        
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        
        self.matchInfoId = postDic["matchInfoId"] as? String
        
        if let likes = postDic["likes"] as? [String] {
            self.likes = likes
        }
        if let myid = Auth.auth().currentUser?.uid {
            // likesの配列の中にmyidが含まれているかチェックすることで、自分がいいねしているかを判断する
            if self.likes.firstIndex(of: myid) != nil {
                // myidがあれば、いいねしていると認識する
                self.isLiked = true
            }
        }
        
        // このキーはコメントの内容を保持する配列を保存する
        if let commentText = postDic["commentsText"] as? [String] {
            self.commentText = commentText
        }
    }
}
