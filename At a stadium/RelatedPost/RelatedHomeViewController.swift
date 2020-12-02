//
//  RelatedHomeViewController.swift
//  At a stadium
//
//  Created by Yuto Masamura on 202　0/06/17.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class RelatedHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var relatedCategorySectionLabel: UILabel!
    @IBOutlet weak var relatedHomeTeamLabel: UILabel!
    @IBOutlet weak var relatedAwayTeamLabel: UILabel!
    @IBOutlet weak var relatedStadiumLabel: UILabel!
    @IBOutlet weak var relatedStadiumImageView: UIImageView!
    @IBOutlet weak var relatedDateLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    // HomeVCから受け取った補足情報となる試合情報
    var matchInfoFromHomeVC: MatchData?
    
    // 投稿データを格納する配列
    var relatedPostArray: [PostData] = []
    
    // 試合情報データを格納する配列
    var relatedMatchInfoArray: [MatchData] = []
    
    var listener: ListenerRegistration!
    
    var matchInfolistener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 500
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // カスタムセルを登録する
        let nib = UINib(nibName: "RelatedHeaderTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "RelatedHeaderCell")
        
        let nib2 = UINib(nibName: "RelatedPostsTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "RelatedPostsCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        
        if Auth.auth().currentUser != nil {
            // ログイン済み
            if listener == nil || matchInfolistener == nil {
                // listener未登録なら、登録してスナップショットを受信する
                let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
                listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                    if let error = error {
                        print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                        return
                    }
                    
                    // 取得したdocumentをもとにPostDataを作成し、relatedPostArrayの配列に代入している。
                    // documentsはDocumentの配列。このドキュメントをPostDataに変換している。
                    // mapメソッドは、各要素を変換して新しい配列を生成する。今回であれば、Document -> PostDataに変換する処理を行っている。
                    // filterメソッドは条件に合う要素を絞り込む処理で、各PostDataの持っているmatchInfoIdを比較の条件に使っている。
                    
                    // $0はクロージャの引数名を背負い略したときに自動的に割り振られる変数。引数が3つであれば、$0~$2といったように各番号が割り当てられる。
                    // mapで$0を使わない場合
                    // .map { document in PostData(document: document) }
                    
                    self.relatedPostArray = querySnapshot!.documents
                        .map { PostData(document: $0) }
                        .filter { $0.matchInfoId == self.matchInfoFromHomeVC!.id
                        }
                    
                    
                    // わからなくて、書いてみたコード
                    //                    self.relatedPostArray = querySnapshot!.documents.map { document in
                    //                        print("DEBUG_PRINT: document取得 \(document.documentID)")
                    //                        let postData = PostData(document: document)
                    //
                    //                        if postData.matchInfoId == self.matchInfoFromHomeVC!.id {
                    //                            let relatedPostData = postData
                    //                        }
                    //                        return relatedPostData
                    //
                    //                    }
                    
                    // TableViewの表示を更新する
                    self.tableView.reloadData()
                }
                
                
                // listener未登録なら、登録してスナップショットを受信する
                let matchInfoPostRef = Firestore.firestore().collection(Const.MatchCreatePath).order(by: "date", descending: true)
                matchInfolistener = matchInfoPostRef.addSnapshotListener() { (querySnapshot, error) in
                    if let error = error {
                        print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                        return
                    }
                    // 取得したdocumentをもとにSelectedMatchInfoDataを作成し、SelectedMatchInfoDataArrayの配列にする。
                    self.relatedMatchInfoArray = querySnapshot!.documents.map { document in
                        print("DEBUG_PRINT: document取得 \(document.documentID)")
                        let matchData = MatchData(document: document)
                        
                        print("--------------------------")
                        print(matchData.id)
                        print("カテゴリセクション\(String(describing: matchData.category))")
                        print("セクション\(String(describing: matchData.section))")
                        print("ホーム\(String(describing: matchData.homeTeam))")
                        print("アウェイ\(String(describing: matchData.awayTeam))")
                        print("デート\(String(describing: matchData.date))")
                        
                        return matchData
                    }
                    // TableViewの表示を更新する
                    self.tableView.reloadData()
                }
            }
        } else {
            if listener != nil {
                // listener登録済みなら削除してpostArrayをクリアする
                listener.remove()
                listener = nil
                relatedPostArray = []
                
                // listener登録済みなら削除してSelectedMatchInfoDataArrayをクリアする
                matchInfolistener.remove()
                matchInfolistener = nil
                relatedMatchInfoArray = []
                
                tableView.reloadData()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relatedPostArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RelatedHeaderCell", for: indexPath) as! RelatedHeaderTableViewCell
            cell.setMatchInfo(self.matchInfoFromHomeVC!)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RelatedPostsCell", for: indexPath) as! RelatedPostsTableViewCell
            cell.setPostData(relatedPostArray[indexPath.row - 1])
            
            return cell
        }
    }
}
