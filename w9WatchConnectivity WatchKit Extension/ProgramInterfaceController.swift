//
//  ProgramInterfaceController.swift
//  w9WatchConnectivity WatchKit Extension
//
//  Created by Ali Muhammad on 2019-11-04.
//  Copyright © 2019 Ali Muhammad. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class ProgramInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var progTable : WKInterfaceTable!
    var programs : [ProgramObject] = []
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if(WCSession.isSupported())
        {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if WCSession.default.isReachable
        {
            let message = ["getProgData" : [:]]
            
            WCSession.default.sendMessage(message, replyHandler: { (result)
                in
                
                if result["progData"] != nil
                {
                    let loadedData = result["progData"]
                    NSKeyedUnarchiver.setClass(ProgramObject.self, forClassName: "ProgramObject")
                    
                    
                    let loadedPerson = NSKeyedUnarchiver.unarchiveObject(with: loadedData as! Data) as? [ProgramObject]
                    self.programs = loadedPerson!
                    
                    self.progTable.setNumberOfRows(self.programs.count, withRowType: "ProgRowController")
                    
                    for(index, prog) in self.programs.enumerated()
                    {
                        let row = self.progTable.rowController(at: index) as! ProgRowController
                        
                        row.lbTitle.setText(prog.title)
                        row.lbSpeaker.setText(prog.speaker)
                        row.lbFrom.setText(prog.from)
                        row.lbTo.setText(prog.to)
                    }
                }
                
            }) { (error) in
                print(error)
            }
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
