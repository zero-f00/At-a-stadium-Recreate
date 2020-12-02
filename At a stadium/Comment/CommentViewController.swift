//
//  CommentViewController.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/08/24.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dockView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var dockViewHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var textViewHeightConstrain: NSLayoutConstraint!
    
    // HomeVCで選択された投稿データ
    var postData: PostData!
    
    // 投稿データを格納する配列
    var commentPostArray: [PostData] = []
    
    // Firestoreのリスナー
    var listener: ListenerRegistration!
    
    var isObserving = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        textView.delegate = self
        
        // カスタムセルを登録する
        // 投稿データ用のnib
        let nib = UINib(nibName: "CommentVCPostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CommentVCPostCell")
        
        // コメント表示用のnib
        let nib2 = UINib(nibName: "CommentTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "CommentCell")
        
        dockView.backgroundColor = UIColor.red
        
        // キャプションを入力するテキストエリアをからの状態にしておく
        textView.text = ""
        
//        self.textView.becomeFirstResponder()
        
                // キーボードのframeに変化があった場合にメソッドを呼ぶ
                let center = NotificationCenter.default
                center.addObserver(self, selector: #selector(handleKeyboardWillShowNotification), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
                center.addObserver(self, selector: #selector(handleKeyboardWillHideNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
                // TableViewのドラッグ開始時にキーボードを閉じる。
                self.tableView.keyboardDismissMode = .onDrag
        
        // TableViewを下にスクロールするのに合わせてキーボードを閉じる。
        self.tableView.keyboardDismissMode = .interactive
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // tabBarを表示
        tabBarController?.tabBar.isHidden = false
        
        if(!isObserving) {
            // Viewの表示時にキーボード表示・非表示を監視するObserverを登録する
            let center = NotificationCenter.default
            center.addObserver(self, selector: #selector(handleKeyboardWillShowNotification), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
            
            center.addObserver(self, selector: #selector(handleKeyboardWillHideNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
            isObserving = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        
        if(!isObserving) {
            // Viewの表示時にキーボード表示・非表示を監視するObserverを登録する
            let center = NotificationCenter.default
            center.addObserver(self, selector: #selector(handleKeyboardWillShowNotification), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
            
            center.addObserver(self, selector: #selector(handleKeyboardWillHideNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
            isObserving = true
        }
        
        // tabBarを非表示
        tabBarController?.tabBar.isHidden = true
        
        if Auth.auth().currentUser != nil {
            // ログイン済み
            if listener == nil {
                // listener未登録なら、登録してスナップショットを受信する
                let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
                listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                    if let error = error {
                        print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                        return
                    }
                    
                    self.commentPostArray = querySnapshot!.documents
                        .map { PostData(document: $0) }
                        .filter { $0.id == self.postData!.id
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
                commentPostArray = []
                
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentPostArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentVCPostCell", for: indexPath) as! CommentVCPostTableViewCell
            cell.setCommentVCPostData(postData)
            return cell
        } else {
            // セルを取得してデータを設定する
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
            cell.setCommentPostData(commentPostArray[indexPath.row - 1])
            
            return cell
        }
    }
    
    @IBAction func handleCommentPostButton(_ sender: Any) {
        self.textView.endEditing(true)
        
        let commentTextField = textView.text!
        
        // commentsを更新する
        if let myid = Auth.auth().currentUser?.displayName {
            
            if commentTextField.isEmpty {
                SVProgressHUD.showError(withStatus:"コメントを入力してください。")
            } else {
                
                // 更新データを作成する
                var updateValueComment: FieldValue
                updateValueComment = FieldValue.arrayUnion([myid + commentTextField])
                
                // commentsTextに更新データを書き込む
                let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
                postRef.updateData(["commentsText": updateValueComment])
                
                textView.text! = ""
                
                //                // TableViewを一番下までスクロールする
                //                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
                
                SVProgressHUD.showSuccess(withStatus: "投稿しました。")
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //キーボード表示される寸前
    @objc func handleKeyboardWillShowNotification(_ notification: Notification) {
        
//        // キーボード表示時の動作をここに記述する
//        let rect = ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey])! as! NSValue).cgRectValue
//        let duration:TimeInterval = ((notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]) as! Double)
//        UIView.animate(withDuration: duration, animations: {
//            let transform = CGAffineTransform(translationX: 0, y: -rect.size.height)
//            self.view.transform = transform
//        },completion:nil)
        
        
                //キーボードの大きさを取得
                let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
                UIView.animate(withDuration: 0.25, animations: {
        
                    //キーボードの高さの分DockViewの高さをプラス
                    self.dockViewHeightConstrain.constant = (keyboardRect?.size.height)! + 60
                    self.view.layoutIfNeeded()
                }, completion: nil)
    }
    
    //キーボードが隠れる寸前
    @objc func handleKeyboardWillHideNotification(_ notification: Notification) {
        
//        // キーボード消滅時の動作をここに記述する
//        let duration = ((notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]) as! Double)
//        UIView.animate(withDuration: duration, animations:{
//            self.view.transform = CGAffineTransform.identity
//        },
//        completion:nil)
        
        
                UIView.animate(withDuration: 0.25, animations: {
        
                    //DockViewの高さを元の高さに戻す
                    self.dockViewHeightConstrain.constant = 60
                    self.view.layoutIfNeeded()
                }, completion: nil)
    }
    
//    func textViewDidChange(_ textView: UITextView) {
//        let maxHeight = 80.0  // 入力フィールドの最大サイズ
//        if(textView.frame.size.height.native < maxHeight) {
//            let size:CGSize = textView.sizeThatFits(textView.frame.size)
//            textViewHeightConstrain.constant = size.height
//        }
//    }
}
