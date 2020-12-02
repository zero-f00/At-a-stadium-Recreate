//
//  Const.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/05/07.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import Foundation

struct Const {
    // ImagePathは、Storage内の画像ファイルの保存場所
    static let ImagePath = "images"
    
    // PostPathは、Firestore内の投稿データ(投稿者名、キャプション、投稿日時等)の保存場所
    static let PostPath = "posts"

    // stadiumImagePathは、Storage内の画像ファイルの保存場所
    static let stadiumImagePath = "stadiumImages"
    
    // MatchCreatePathはFirestore内の投稿データ(カテゴリ、セクション、チーム、キックオフの時間等)の保存場所
    static let MatchCreatePath = "matchCreate"
    
    // ProfilePathは、Firestore内のプロフィールデータ（お気に入りチーム、自己紹介）
    static let ProfilePath = "profileData"
    
    // ImagePathは、Storage内の画像ファイルの保存場所
    static let ProfileImagePath = "profileImages"
}
