//
//  HomeViewController.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/05/03.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // 投稿データを格納する配列
    var postArray: [PostData] = []
    
    // 補足情報の試合情報データを格納する配列
    var matchInfoArray: [MatchData] = []
    
//    // matchCreateViewControllerで作成し、引き継いできた試合情報受け取る変数
//    // 投稿時にPostPathに一緒に保存してしまうため不要
//    // 試合情報を格納する変数
//    var matchInfo: MatchData?
    
    // RelatedHomeViewControllerに補足情報となる試合情報を表示させるための変数
    var matchInfoToRelated: MatchData?
    
    // CommentVCに渡す投稿データのための変数
    var toCommentVCPostData: PostData?
    
    var listener: ListenerRegistration!
    
    var matchInfolistener: ListenerRegistration!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.rowHeight = 900
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        
        // カスタムセルを登録する
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
    }
    
        override func viewWillAppear(_ animated:Bool) {
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
                        // 最新の情報を取得するための処理
                        // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                        self.postArray = querySnapshot!.documents.map { document in
                            print("DEBUG_PRINT: document取得 \(document.documentID)")
                            let postData = PostData(document: document)
                            return postData
                        }
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
                        self.matchInfoArray = querySnapshot!.documents.map { document in
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
                    postArray = []
                    
                    // listener登録済みなら削除してSelectedMatchInfoDataArrayをクリアする
                    matchInfolistener.remove()
                    matchInfolistener = nil
                    matchInfoArray = []
                    
                    tableView.reloadData()
                }
            }
        }
    
    // TableViewに表示するセルの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])
        
        let postData = postArray[indexPath.row]
        
        for matchInfo in matchInfoArray {
            if postData.matchInfoId == matchInfo.id {
                cell.setMatchData(matchInfo)
                break
            }
        }
        cell.addMatchInfoButton.addTarget(self, action: #selector(didTapAddMatchInfo), for: .touchUpInside)
        
        cell.commentButton.addTarget(self, action: #selector(hundleCommentButton), for: .touchUpInside)
        
        return cell
    }
    
    @objc func hundleCommentButton(_ sender:UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: コメントボタンがタップされました。CommentViewControllerに遷移し、タップしたセルの情報を渡す。")
        
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let postData = postArray[indexPath!.row]
        
        toCommentVCPostData = postData
        
        self.performSegue(withIdentifier: "toCommentVC", sender: self)
    }
    
    // 補足情報となる試合情報の子Viewをタップした時
    @objc func didTapAddMatchInfo(_ sender: UIButton, forEvent event: UIEvent) {
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let postData = postArray[indexPath!.row]
        
        for matchInfo in matchInfoArray {
            if postData.matchInfoId == matchInfo.id {
                // PostDataに保存されているMatchInfoのidと一致するものを次のviewに渡す
                matchInfoToRelated = matchInfo
                break
            }
        }
        
        // viewがタップされた時のアクション
        self.performSegue(withIdentifier: "toRelatedHomeVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toRelatedHomeVC" {
            let relatedHomeViewController = segue.destination as! RelatedHomeViewController
            relatedHomeViewController.matchInfoFromHomeVC = matchInfoToRelated
            print("DEBUG_PRINT matchInfoFromHomeVCに値を渡す \(String(describing: matchInfoToRelated))")
        } else if segue.identifier == "toCommentVC" {
            let commentViewController = segue.destination as! CommentViewController
            commentViewController.postData = toCommentVCPostData
        }
    }

}
