//
//  CategorySelectNavigationViewController.swift
//  At a stadium
//
//  Created by Yuto Masamura on 2020/05/23.
//  Copyright © 2020 Yuto Masamura. All rights reserved.
//

import UIKit

class CategorySelectNavigationViewController: UIViewController {

    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func backButton_Clicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
