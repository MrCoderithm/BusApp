//
//  ProgramViewController.swift
//  w9WatchConnectivity
//
//  Created by Ali Muhammad on 2019-11-04.
//  Copyright © 2019 Ali Muhammad. All rights reserved.
//

import UIKit
import WatchConnectivity

class ProgramViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WCSessionDelegate {
    
    
    var lastMessage : CFAbsoluteTime = 0
    var programs : [ProgramObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFakeDetails()
        
        if WCSession.isSupported()
        {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        var replyValues = Dictionary<String, AnyObject>()
        
        if message["getProgData"] != nil
        {
            NSKeyedArchiver.setClassName("ProgramObject", for: ProgramObject.self)
            let progData = try?
                NSKeyedArchiver.archivedData(withRootObject: programs, requiringSecureCoding: false)
            
            replyValues["progData"] = progData as AnyObject?
            replyHandler(replyValues)
        }
        
    }
    
    
    func initFakeDetails()
    {
        let progObj = ProgramObject()
        progObj.initWithData(title: "Route 32", speaker: "Mr.Paul", to: "4:00", from: "Mon Nov 4, 3:15PM", details: "Bus arrives early")
        programs.append(progObj)
        
        
        let progObj1 = ProgramObject()
        progObj1.initWithData(title: "Route 39B", speaker: "Mr. Kang", to: "5:00", from: "Mon Nov 4, 4:15PM", details: "On time")
        programs.append(progObj1)
        
        
        let progObj2 = ProgramObject()
        progObj2.initWithData(title: "Route 4", speaker: "Ali Muhammad", to: "6:00", from: "Mon Nov 4, 5:15PM", details: "On time")
        programs.append(progObj2)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return programs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell : ProgramTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProgramCell") as? ProgramTableViewCell ?? ProgramTableViewCell(style: .default, reuseIdentifier: "ProgramCell")
        
        let rowObj = programs[indexPath.row]
        tableCell.title.text = rowObj.title
        tableCell.speaker.text = rowObj.speaker
        tableCell.to.text = rowObj.to
        tableCell.from.text = rowObj.from
        // tableCell.details.text = rowObj.details
        // do a popup for details we didn't implement anything so far
        
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    
    // Watch OS Mandatory Methods
    // To show we can handle what happens when watch gets out of connectivitiy
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
}
