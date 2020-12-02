//
//  MyPageEditViewController.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/06/18.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import SDWebImage

class MyPageEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let firebaseAuth = Auth.auth()
    let imagePick = UIImagePickerController()
    
    var localImageURL: NSURL?
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var favoriteTeam: UITextField!
    @IBOutlet weak var selfIntroduction: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imagePick.delegate = self
        
        let user = Auth.auth().currentUser
        if let user = user {
            
            // ユーザー名の表示
            displayNameTextField.text = user.displayName
            
            // プロフィール画像読み込み
            SDWebImageManager.shared.loadImage(with: user.photoURL, options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                self.profileImage.image = image
            }
        }
        
    }
    
    @IBAction func tapProfileImage(_ sender: Any) {
        imagePick.sourceType = .photoLibrary
        imagePick.modalPresentationStyle = .fullScreen
        present(imagePick, animated: true, completion: nil)
    }
    
    // カメラロールから写真を選択
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        
        
        if let pickedImage = info[.originalImage] as? UIImage {
            self.profileImage.contentMode = .scaleAspectFit
            self.profileImage.image = pickedImage
        }
        
        //        // 保存のアラートを出す
        //        let alert: UIAlertController = UIAlertController(title: "保存する", message: "プロフィールを設定します。", preferredStyle: UIAlertController.Style.alert)
        //
        //        // OKの場合
        //        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
        //
        //            (action: UIAlertAction!) -> Void in
        //            print("OK")
        //
        //            if let pickedImage = info[.originalImage] as? UIImage {
        //                self.profileImage.contentMode = .scaleAspectFit
        //                self.profileImage.image = pickedImage
        //            }
        //
        //            self.upload()
        //        })
        
        //        // キャンセルの場合
        //        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: {
        //
        //            (action: UIAlertAction!) -> Void in
        //            print("選択をキャンセルしました。")
        //        })
        //
        //        alert.addAction(defaultAction)
        //        alert.addAction(cancelAction)
        
        //        self.present(alert, animated: true, completion: nil)
    }
    
    // 写真選択をキャンセル
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        print("キャンセルされました。")
    }
    
    @IBAction func handleSaveButton(_ sender: Any) {
        
        if let displayName = displayNameTextField.text {
            
            // ユーザー名未入力
            if displayName.isEmpty {
                SVProgressHUD.showError(withStatus: "ユーザー名を入力してください")
                return
            }
            
            // ユーザー名を設定する
            let user = Auth.auth().currentUser
            if let user = user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = displayName
                changeRequest.commitChanges { error in
                    if let error = error {
                        SVProgressHUD.showError(withStatus: "ユーザー名の変更に失敗しました")
                        print("DEBUG_PRINT: " + error.localizedDescription)
                        return
                    }
                    print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に失敗しました")
                    
                    self.upload()
                    
                    SVProgressHUD.showSuccess(withStatus: "プロフィールを変更しました")
                    
                    
                }
            }
            self.view.endEditing(true)
        }
    }
    
    // プロフィール画像をアップロード
    fileprivate func upload() {
        
        // 画像をJPEG形式に変換する
        // postImage
        let imageData = self.profileImage.image?.jpegData(compressionQuality: 0.75)
        // 画像と投稿データの保存場所を定義
        let postRef = Firestore.firestore().collection(Const.ProfilePath).document()
        let imageRef = Storage.storage().reference().child(Const.ProfileImagePath).child(postRef.documentID + ".jpg")
        
        // HUDで投稿処理中の表示を開始
        SVProgressHUD.show()
        
        // Storageに投稿内容の画像をアップロードする
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        imageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
            if error != nil {
                // 画像のアップロードに失敗
                print(error!)
                SVProgressHUD.showError(withStatus: "画像のアップロードに失敗しました。")
                print("error: \(error!.localizedDescription)")
                
                // 投稿処理をキャンセル
                UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    
                    print("url: \(url!.absoluteString)")
                    
                    let changeRequest = self.firebaseAuth.currentUser?.createProfileChangeRequest()
                    if let photoURL = URL(string: url!.absoluteString) {
                        changeRequest?.photoURL = photoURL
                    }
                    
                    changeRequest?.commitChanges { (error) in
                        SVProgressHUD.showError(withStatus: "プロフィール画像の変更に失敗しました。")
                        print("DEBUG_PRINT: " + error!.localizedDescription)
                        return
                    }
                }
            })
        }
    }
    
}
