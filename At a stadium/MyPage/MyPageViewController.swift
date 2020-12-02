//
//  MyPageViewController.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/05/03.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class MyPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    // 投稿データを格納する配列
    var myPostArray: [PostData] = []

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
        let nib = UINib(nibName: "MyPageHeaderTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MyPageHeaderViewCell")

        let nib2 = UINib(nibName: "MyPagePostedTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "MyPagePostedViewCell")
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

                        self.myPostArray = querySnapshot!.documents
                            .map { PostData(document: $0) }
                            .filter { $0.name == Auth.auth().currentUser?.displayName
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
                    myPostArray = []

                    // listener登録済みなら削除してSelectedMatchInfoDataArrayをクリアする
                    matchInfolistener.remove()
                    matchInfolistener = nil
                    matchInfoArray = []

                    tableView.reloadData()
                }
            }
        }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPostArray.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageHeaderViewCell", for: indexPath) as! MyPageHeaderTableViewCell
//            cell.setProfileData()
            
            cell.SettingsButton.addTarget(self, action: #selector(hundleSettingsButton), for: .touchUpInside)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPagePostedViewCell", for: indexPath) as! MyPagePostedTableViewCell
            cell.setMyPostData(myPostArray[indexPath.row - 1])
            
            return cell
        }
    }
    
    @objc func hundleSettingsButton(_ sender:UIButton, forEvent event: UIEvent) {
        
        print("DEBUG_PRINT: プロフィール編集ボタンがタップされました。遷移する。")
        
        let myPageEditViewController = self.storyboard?.instantiateViewController(identifier: "toSettings") as! MyPageEditViewController
        
        self.present(myPageEditViewController, animated: false, completion: nil)
    }

}
