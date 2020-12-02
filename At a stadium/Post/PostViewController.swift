//
//  PostViewController.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/05/04.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import UIKit
import YPImagePicker
import Firebase
import SVProgressHUD
import FirebaseUI


class PostViewController: UIViewController {
    
    var image: UIImage!
    
    var config = YPImagePickerConfiguration()
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    @IBOutlet weak var matchInfoAreaLabel: UILabel!
    @IBOutlet weak var categorySectionLabel: UILabel!
    
    
    @IBOutlet weak var matchInfoUIView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var awayTeamLabel: UILabel!
    @IBOutlet weak var stadiumImageView: UIImageView!
    
    
    var matchInfo: MatchData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // キャプションを入力するテキストエリアをからの状態にしておく
        caption.text = ""
        // viewが立ち上がった直後にキーボードが立ち上がるようにする
        caption.becomeFirstResponder()
        
        // YPImagePickerのタブの名前
        config.wordings.libraryTitle = "ライブラリ"
        config.wordings.cameraTitle = "写真"
        config.wordings.next = "OK"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("PostVC-viewWillAppearが呼ばれました。")
        
        print("DEBUG_PRINT PostVCで値は\(String(describing: matchInfo))です。")
        
        // 試合情報の追加がされているかどうかを判定する
        
        if matchInfo != nil {
            print("PostVCで呼ばれています。")
            
            postButton.isEnabled = true
            
            // 非表示にする
            matchInfoAreaLabel.isHidden = true
            matchInfoUIView.isHidden = false
            
            
            // カテゴリの表示 セクションの表示
            self.categorySectionLabel.text = "\(matchInfo!.category!) \(matchInfo!.section!)"
            print("DEBUG_PRINT \(String(describing: self.categorySectionLabel.text))")

            // KICKOFFの表示
            self.dateLabel.text = ""
            if let date = matchInfo!.date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                let dateAndTime = date.formattedDateWith(style: .longDateAndTime)
                self.dateLabel.text = "KICKOFF - \(dateAndTime)"
            }
            
            print("DEBUG_PRINT \(String(describing: self.dateLabel.text))")

            // ホームチームの表示
            self.homeTeamLabel.text = matchInfo!.homeTeam!
            print("DEBUG_PRINT \(String(describing: self.homeTeamLabel.text))")

            // アウェイチームの表示
            self.awayTeamLabel.text = matchInfo!.awayTeam!
            print("DEBUG_PRINT \(String(describing: self.awayTeamLabel.text))")

            //        // スタジアムの表示
            //        self.stadiumLabel.text = "KICKOFF - \(matchInfoDetail!stadium!)"
            //        print("DEBUG_PRINT \(String(describing: self.stadiumLabel.text))")

            setMatchData(matchInfo!)
            
            
        } else {
            matchInfoAreaLabel.isHidden = false
            matchInfoUIView.isHidden = true
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setMatchData(_ matchData: MatchData) {
        // スタジアム画像の表示
        stadiumImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.stadiumImagePath).child(matchData.id + ".jpg")
        stadiumImageView.sd_setImage(with: imageRef)
        print("DEBUG_PRINT \(imageRef)")

    }
    
    @IBAction func backButton_Clicked(_ sender: Any) {
        caption.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postButton_Clicked(_ sender: Any) {
        
        if self.image == nil {
            SVProgressHUD.showError(withStatus:"画像の投稿は必須です。")
            postButton.isEnabled = false
            mastTapImage()
        } else if matchInfo == nil {
            SVProgressHUD.showError(withStatus:"試合情報の追加は必須です。")
            postButton.isEnabled = false
        } else {
            
            // キーボードを閉じる
            caption.resignFirstResponder()
            
            // 画像をJPEG形式に変換する
            // postImage
            let imageData = image.jpegData(compressionQuality: 0.75)
            
            // 画像と投稿データの保存場所を定義
            let postRef = Firestore.firestore().collection(Const.PostPath).document()
            let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
            
            // HUDで投稿処理中の表示を開始
            SVProgressHUD.show()
            
            // Storageに投稿内容の画像をアップロードする
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            imageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
                if error != nil {
                    // 画像のアップロードに失敗
                    print(error!)
                    SVProgressHUD.showError(withStatus: "画像のアップロードに失敗しました。")
                    
                    // 投稿処理をキャンセル
                    UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                    return
                }
                
                // FireStoreに投稿データを保存する
                let name = Auth.auth().currentUser?.displayName
                let postDic = [
                    "name": name!,
                    "caption": self.caption.text!,
                    "date": FieldValue.serverTimestamp(),
                    "matchInfoId": self.matchInfo!.id,
                ] as [String : Any]
                postRef.setData(postDic)
                
                
//                // matchCreateViewControllerで作成し、引き継いできた試合情報をHomeViewControllerに渡す
//                // idから対象のデータを取得するため不要
//                let navigationController = self.presentingViewController as! UINavigationController
//
//                let HomeViewController = navigationController.topViewController as! HomeViewController
//                HomeViewController.matchInfo = self.matchInfo
                
                // HUDで投稿完了を表示
                SVProgressHUD.showSuccess(withStatus: "投稿完了")
                
                
                
                // 投稿処理が完了したので先頭画面に戻る
                UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func tapImage(_ sender: Any) {
        
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                // 受け取った画像をImageViewに設定する
                self.postImage.image = photo.originalImage
                self.image = photo.originalImage
                self.postButton.isEnabled = true
            }
            picker.dismiss(animated: true, completion: nil)

        }
        present(picker, animated: true, completion: nil)
    }
    
    func mastTapImage() {
        
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                // 受け取った画像をImageViewに設定する
                self.postImage.image = photo.originalImage
                self.image = photo.originalImage
                // ポストボタンを押せるようにする
                self.postButton.isEnabled = true
            }
            picker.dismiss(animated: true, completion: nil)

        }
        present(picker, animated: true, completion: nil)
    }
    
}
