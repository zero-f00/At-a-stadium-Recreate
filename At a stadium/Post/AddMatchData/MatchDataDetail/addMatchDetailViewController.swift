//
//  addMatchDetailViewController.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/05/24.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import UIKit
import FirebaseUI

class addMatchDetailViewController: UIViewController {
    
    @IBOutlet weak var categorySectionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var awayTeamLabel: UILabel!
    @IBOutlet weak var stadiumLabel: UILabel!
    @IBOutlet weak var stadiumImageView: UIImageView!
    
    var matchInfoDetail: MatchData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // カテゴリの表示 セクションの表示
        self.categorySectionLabel.text = "\(matchInfoDetail!.category!) \(matchInfoDetail!.section!)"
        print("DEBUG_PRINT \(String(describing: self.categorySectionLabel.text))")
        
        // KICKOFFの表示
        self.dateLabel.text = ""
        if let date = matchInfoDetail!.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateAndTime = date.formattedDateWith(style: .longDateAndTime)
            self.dateLabel.text = "KICKOFF - \(dateAndTime)"
        }
        print("DEBUG_PRINT \(String(describing: self.dateLabel.text))")
        
        // ホームチームの表示
        self.homeTeamLabel.text = "\(matchInfoDetail!.homeTeam!)"
        print("DEBUG_PRINT \(String(describing: self.homeTeamLabel.text))")
        
        // アウェイチームの表示
        self.awayTeamLabel.text = "\(matchInfoDetail!.awayTeam!)"
        print("DEBUG_PRINT \(String(describing: self.awayTeamLabel.text))")
        
//        // スタジアムの表示
//        self.stadiumLabel.text = "KICKOFF - \(matchInfoDetail!stadium!)"
//        print("DEBUG_PRINT \(String(describing: self.stadiumLabel.text))")
        
        setMatchData(matchInfoDetail!)
    }
    
    func setMatchData(_ matchData: MatchData) {
        // スタジアム画像の表示
        stadiumImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.stadiumImagePath).child(matchData.id + ".jpg")
        stadiumImageView.sd_setImage(with: imageRef)
        print("DEBUG_PRINT \(imageRef)")
        
    }
    
    @IBAction func addMatchInfoButton(_ sender: Any) {
        
        let navigationController = self.presentingViewController as! UINavigationController
        
        let postViewController = navigationController.topViewController as! PostViewController
        postViewController.matchInfo = matchInfoDetail
        
        let settingsTableViewController = postViewController.children[0] as! SettingsTableViewController
        settingsTableViewController.choosedMatchInfoDetail = matchInfoDetail
        
        self.dismiss(animated: true, completion: nil)
    }

}
