//
//  AppDelegate.swift
//  BusApp
//
//  Created by Ali Muhammad on 2019-10-24.
//  Copyright © 2019 Ali Muhammad. All rights reserved.
//

import Foundation
import UIKit

class InitialViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //- Todo: Check if user is authenticated. If so, segue to the HomeViewController, otherwise, segue to the MenuViewController
     
        self.performSegue(withIdentifier: "toMenuScreen", sender: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
}
