//
//  MatchDataViewController.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/05/19.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import UIKit
import Firebase

class MatchDataViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // 試合データを格納する入れる
    var matchInfoArray: [MatchData] = []
    var matchInfo: MatchData?
    
    // Firestoreのリスナー
    var listener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // カスタムセルを登録する
        let nib = UINib(nibName: "addMatchDataTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MatchCell")
        
        tableView.rowHeight = 157
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        
        if Auth.auth().currentUser != nil {
            // ログイン済み
            if listener == nil {
                // listener未登録なら、登録してスナップショットを受信する
                let postsRef = Firestore.firestore().collection(Const.MatchCreatePath).order(by: "date", descending: true)
                listener = postsRef.addSnapshotListener() { (QuerySnapshot, error) in
                    if let error = error {
                        print("DEBUG_PRINT: snapshotの取得が失敗しました。\(error)")
                        return
                    }
                    // 取得したdocumentをもとにMatchDataを作成し、matchInfoArrayの配列にする。
                    self.matchInfoArray = QuerySnapshot!.documents.map { document in
                        print("DEBUG_PRINT: document取得 \(document.documentID)")
                        let matchData = MatchData(document: document)
                        return matchData
                    }
                    // TableViewを更新する
                    self.tableView.reloadData()
                }
            }
        } else {
            // ログアウト未（またはログアウト済み）
            if listener != nil {
                // listener登録済みなら削除してmatchInfoArrayをクリアする
                listener.remove()
                listener = nil
                matchInfoArray = []
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchInfoArray.count
    }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath) as! addMatchDataTableViewCell
        cell.setMatchData(matchInfoArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        matchInfo = matchInfoArray[indexPath.row]
        
        // セルがタップされた時のアクション
        performSegue(withIdentifier: "cellSegue",sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let AddMatchDetailViewController = segue.destination as! addMatchDetailViewController
        AddMatchDetailViewController.matchInfoDetail = matchInfo
        print("DEBUG_PRINT \(String(describing: matchInfo))")
    }

}
