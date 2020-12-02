//
//  matchCreateViewController.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/05/12.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import YPImagePicker

class matchCreateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var image:UIImage!
    
    var config = YPImagePickerConfiguration()
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var section: UITextField!
    
    @IBOutlet weak var hTeam: UITextField!
    @IBOutlet weak var aTeam: UITextField!
    
    @IBOutlet weak var matchDatePicker: UIDatePicker!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var categoryPickerView: UIPickerView = UIPickerView()
    var sectionPickerView: UIPickerView = UIPickerView()
    var hTeamsPickerView: UIPickerView = UIPickerView()
    var aTeamsPickerView: UIPickerView = UIPickerView()
    
    let categoryList: [String]  = [
        "--", "明治安田生命J1リーグ", "明治安田生命J2リーグ",
    ]
    
    let sectionList: [String]  = [
        "--", "第1節", "第2節", "第3節", "第4節", "第5節", "第6節", "第7節", "第8節", "第9節", "第10節",
        "第11節", "第12節", "第13節", "第14節", "第15節", "第16節", "第17節", "第18節", "第19節", "第20節",
        "第21節", "第22節", "第23節", "第24節", "第25節", "第26節", "第27節", "第28節", "第29節", "第30節",
        "第31節", "第32節", "第33節", "第34節", "第35節", "第36節", "第37節", "第38節", "第39節", "第40節",
        "第41節", "第42節", "第43節", "第44節", "第45節", "第46節", "第47節", "第48節", "第49節", "第50節",
        "第51節", "第52節",
        "決勝", "準決勝", "準々決勝", "準決勝（第1戦）", "準決勝（第2戦）", "準々決勝（第1戦）", "準々決勝（第2戦）",
        "第1戦", "第2戦", "第3戦", "第4戦", "第5戦",
        "1回戦", "2回戦", "3回戦", "4回戦", "5回戦",
    
    ]
    
    let hTeamsList: [String]  = [
        "--", "北海道コンサドーレ札幌", "ベガルタ仙台", "鹿島アントラーズ",
    ]
    
    let aTeamsList: [String]  = [
        "--", "北海道コンサドーレ札幌", "ベガルタ仙台", "鹿島アントラーズ",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // YPImagePickerのタブの名前
        config.wordings.libraryTitle = "ライブラリ"
        config.wordings.cameraTitle = "写真"
        config.wordings.next = "OK"
        
        // 受け取った画像をImageViewに設定する
        imageView.image = image
        
        // section用
        // pickerViewの位置と大きさを指定
        sectionPickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: sectionPickerView.bounds.size.height)
        sectionPickerView.tag = 2
        sectionPickerView.delegate = self
        sectionPickerView.dataSource = self
        
        // 決定バーの生成
        let sectionToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let sectionSpacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let sectionDoneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))

        sectionToolbar.setItems([sectionSpacelItem, sectionDoneItem], animated: true)
        
        // 初期に選択されているドラムロールの値（必ずしも必要ではない）
        sectionPickerView.selectRow(0, inComponent: 0, animated: true)
        
        // インプットビュー設定
        // ここでいうtextView(self.section.inputViewのsection(元はtextViewとなっていた))はドラムロールで選択した値が収納されるテキストボックス
        self.section.inputView = sectionPickerView
        section.inputAccessoryView = sectionToolbar
        
        
        
        // category用
        // pickerViewの位置と大きさを指定
        categoryPickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: categoryPickerView.bounds.size.height)
        categoryPickerView.tag = 1
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        
        // 決定バーの生成
        let categoryToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let categorySpacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let categoryDoneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))

        categoryToolbar.setItems([categorySpacelItem, categoryDoneItem], animated: true)
        
        // 初期に選択されているドラムロールの値（必ずしも必要ではない）
        categoryPickerView.selectRow(0, inComponent: 0, animated: true)
        
        // インプットビュー設定
        // ここでいうtextViewはドラムロールで選択した値が収納されるテキストボックス
        self.category.inputView = categoryPickerView
        category.inputAccessoryView = categoryToolbar
        
        
        
        // hTeams用
        // pickerViewの位置と大きさを指定
        hTeamsPickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: hTeamsPickerView.bounds.size.height)
        hTeamsPickerView.tag = 3
        hTeamsPickerView.delegate = self
        hTeamsPickerView.dataSource = self
        
        // 決定バーの生成
        let hTeamsToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let hTeamsSpacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let hTeamsDoneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))

        hTeamsToolbar.setItems([hTeamsSpacelItem, hTeamsDoneItem], animated: true)
        
        // 初期に選択されているドラムロールの値（必ずしも必要ではない）
        hTeamsPickerView.selectRow(0, inComponent: 0, animated: true)
        
        // インプットビュー設定
        // ここでいうtextViewはドラムロールで選択した値が収納されるテキストボックス
        self.hTeam.inputView = hTeamsPickerView
        hTeam.inputAccessoryView = hTeamsToolbar
        
        
        // aTeams用
        // pickerViewの位置と大きさを指定
        aTeamsPickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: aTeamsPickerView.bounds.size.height)
        aTeamsPickerView.tag = 4
        aTeamsPickerView.delegate = self
        aTeamsPickerView.dataSource = self
        
        // 決定バーの生成
        let aTeamsToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let aTeamsSpacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let aTeamsDoneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))

        aTeamsToolbar.setItems([aTeamsSpacelItem, aTeamsDoneItem], animated: true)
        
        // 初期に選択されているドラムロールの値（必ずしも必要ではない）
        aTeamsPickerView.selectRow(0, inComponent: 0, animated: true)
        
        // インプットビュー設定
        // ここでいうtextViewはドラムロールで選択した値が収納されるテキストボックス
        self.aTeam.inputView = aTeamsPickerView
        aTeam.inputAccessoryView = aTeamsToolbar
    }
    
    // 決定ボタン押下
    @objc func done() {
        category.endEditing(true)
        category.text = "\(categoryList[categoryPickerView.selectedRow(inComponent: 0)])"
        
        section.endEditing(true)
        section.text = "\(sectionList[sectionPickerView.selectedRow(inComponent: 0)])"
        
        hTeam.endEditing(true)
        hTeam.text = "\(hTeamsList[hTeamsPickerView.selectedRow(inComponent: 0)])"
        aTeam.endEditing(true)
        aTeam.text = "\(aTeamsList[aTeamsPickerView.selectedRow(inComponent: 0)])"
    }
    
    // ドラムロールの数です。今回は一つなので1を返します
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // ドラムロールに表示する値の数を返します
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 1 {
            return categoryList.count
        } else if pickerView.tag == 2 {
            return sectionList.count
        } else if pickerView.tag == 3 {
            return hTeamsList.count
        } else {
            return aTeamsList.count
        }
        
    }

    // ドラムロールに表示する値（文字列）をここで返します
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 1 {
            return categoryList[row]
        } else if pickerView.tag == 2 {
            return sectionList[row]
        } else if pickerView.tag == 3 {
            return hTeamsList[row]
        } else {
            return aTeamsList[row]
        }
        
    }

    // ドラムロールにて選択した値をtextViewに設定します
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 1 {
            self.category.text = categoryList[row]
        } else if pickerView.tag == 2 {
            self.section.text = sectionList[row]
        } else if pickerView.tag == 3 {
            self.hTeam.text = hTeamsList[row]
        } else {
            self.aTeam.text = aTeamsList[row]
        }
        
    }
    
    @IBAction func handleCreateButton(_ sender: Any) {
        if self.image == nil {
            SVProgressHUD.showError(withStatus:"画像の投稿は必須です。")
            
            mastTapImage()
        } else {
            
            // 画像をJPEG形式に変換する
            let imageData = image.jpegData(compressionQuality: 0.75)
            // 画像と投稿データの保存場所を定義
            let postRef = Firestore.firestore().collection(Const.MatchCreatePath).document()
            let imageRef = Storage.storage().reference().child(Const.stadiumImagePath).child(postRef.documentID + ".jpg")
        
        // HUDで投稿処理中の表示を開始
        SVProgressHUD.show()
        
        // Storageに画像をアップロードする
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
            if error != nil {
                // 画像のアップロード失敗
                print(error!)
                SVProgressHUD.showError(withStatus: "画像のアップロードが失敗しました")
                // 投稿処理をキャンセルし、前の画面に戻る
                self.navigationController?.popViewController(animated: true)
                return
            }
            // FireStoreに投稿データを保存する
            let postDic = [
                "category": self.category.text!,
                "section": self.section.text!,
                "homeTeam": self.hTeam.text!,
                "awayTeam": self.aTeam.text!,
                "date": self.matchDatePicker.date,
            ] as [String : Any]
            postRef.setData(postDic)
            // HUDで投稿完了を表示する
            SVProgressHUD.showSuccess(withStatus: "投稿しました")
            // 投稿処理が完了したので先頭画面に戻る
            self.navigationController?.popViewController(animated: true)
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
                self.imageView.image = photo.originalImage
                self.image = photo.originalImage
                
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
                self.imageView.image = photo.originalImage
                self.image = photo.originalImage
            }
            picker.dismiss(animated: true, completion: nil)

        }
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func backButton_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
