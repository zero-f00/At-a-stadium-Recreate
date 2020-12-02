//
//  matchData.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/05/12.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import UIKit
import Firebase

class MatchData: NSObject {
    var id: String
    var category: String?
    var section: String?
    var homeTeam: String?
    var awayTeam: String?
    var date: Date?
    

    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID

        let postDic = document.data()
        
        self.category = postDic["category"] as? String

        self.section = postDic["section"] as? String

        self.homeTeam = postDic["homeTeam"] as? String
        
        self.awayTeam = postDic["awayTeam"] as? String
        
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
    }
}
