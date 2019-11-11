//
//  UserInformationVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/11/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class UserInformationVC: UIViewController {

    @IBOutlet weak var profileImage: ImageVC!
    @IBOutlet weak var changeImageView: BackgroundView!
    @IBOutlet weak var changeEmail: ButtonVC!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideTabBar(status: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar(status: true)
    }
    
    @IBAction func emailButtonPressed(_ sender: Any) {
    
        print("hi")
        
    }
}
