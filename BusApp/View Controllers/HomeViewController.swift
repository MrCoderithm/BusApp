//
//  AppDelegate.swift
//  BusApp
//
//  Created by Ali Muhammad on 2019-10-24.
//  Copyright © 2019 Ali Muhammad. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class HomeViewController:UIViewController {
    
    
    @IBAction func undwindToHomeVC(sender: UIStoryboardSegue){
        
    }
    
    @IBAction func contactView(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleLogout(_ sender:Any) {
        try! Auth.auth().signOut()
        self.dismiss(animated: false, completion: nil)
    }
}
