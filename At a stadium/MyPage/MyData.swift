////
////  MyData.swift
////  At a stadium
////
////  Created by Yuto Masamura on 2020/11/15.
////  Copyright © 2020 Yuto Masamura. All rights reserved.
////
//
//import Foundation
//import Firebase
//
//class MyData: NSObject {
//    var id: String
//    var name: String?
//    var team = String?
//    var selfIntroduction = String?
//    
//    init(document: QueryDocumentSnapshot) {
//        self.id = document.documentID
//        
//        let postDic = document.data()
//        
//        self.name = postDic["name"] as? String
//        
//        self.team = postDic["team"] as? String
//        
//        self.selfIntroduction = postDic["selfIntroduction"]
//        
//        let timestamp = postDic["date"] as? Timestamp
//    }
//}
