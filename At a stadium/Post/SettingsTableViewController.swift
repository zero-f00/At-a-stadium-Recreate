//
//  SettingsTableViewController.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/05/04.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import UIKit
import CoreLocation

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var addPlaceLabel: UILabel!
    @IBOutlet weak var TwitterLabel: UILabel!
    
    @IBOutlet weak var addMatchInfoLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    let shareText = "シェアする"
    let shareUrl = NSURL(string: "https://www.apple.com/jp/")!
    
    //選んだ試合情報を格納する変数
    //addMatchDetailViewControllerで決定した値
    var choosedMatchInfoDetail: MatchData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCurrentLocation()
        tableView.sectionHeaderHeight = 0.1
        
        // 試合情報の追加がされているかどうかを判定する
        tableView.reloadData()
        
        if choosedMatchInfoDetail != nil {
            self.addMatchInfoLabel.text = "試合情報を追加しました。"
        }
        
        // 未使用のcellを非表示
        tableView.tableFooterView = UIView()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("SettingsTableVC-viewWillAppearが呼ばれました。")
        print("DEBUG_PRINT SettingsTableVCで値は\(String(describing: choosedMatchInfoDetail))です。")
        
        // 試合情報の追加がされているかどうかを判定する
        tableView.reloadData()
        
        if choosedMatchInfoDetail != nil {
            self.addMatchInfoLabel.text = "試合情報を追加しました。"
            
            //チーム名を表示する案　長いとawayTeam名が切れてしまう。
//            self.addMatchInfoLabel.text = "\(choosedMatchInfoDetail!.homeTeam!) VS. \(choosedMatchInfoDetail!.awayTeam!)"
        }
    }
    
    @IBAction func shareOnTwitter(_ sender: UISwitch) {
        if sender.isOn {
            let activityItems: [Any] = [shareText, shareUrl]
            let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: [TwitterActivity(message: shareText)])
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    
    func getCurrentLocation() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
       }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // セクションの数を返す
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // それぞれのセクション毎に何行のセルがあるかを返す
            return 3
    }

}


extension SettingsTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
           print("locations = \(locValue.latitude) \(locValue.longitude)")
        //lblLocation.text = "latitude = \(locValue.latitude), longitude = \(locValue.longitude)"
    }
}
