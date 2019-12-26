//
//  ProgramObject.swift
//  w9WatchConnectivity
//
//  Created by Ali Muhammad on 2019-11-04.
//  Copyright © 2019 Ali Muhammad. All rights reserved.
//

import UIKit

class ProgramObject: NSObject, NSCoding {
    
    var title : String?
    var speaker : String?
    var to : String?
    var from : String?
    var details : String?
    
    func initWithData(title: String, speaker: String, to: String, from: String, details: String)
    {
        self.title = title
        self.speaker = speaker
        self.to = to
        self.from = from
        self.details = details
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.speaker, forKey: "speaker")
        aCoder.encode(self.from, forKey: "from")
        aCoder.encode(self.to, forKey: "to")
        aCoder.encode(self.details, forKey: "details")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // guard is looking for nill and if it finds nill then return nill
        // opposite of an if statement
        guard let title = aDecoder.decodeObject(forKey: "title") as? String,        let speaker = aDecoder.decodeObject(forKey: "speaker") as? String, let from = aDecoder.decodeObject(forKey: "from") as? String, let to = aDecoder.decodeObject(forKey: "to") as? String, let details = aDecoder.decodeObject(forKey: "details") else {return nil}
        
        self.init()
        self.initWithData(title: title, speaker: speaker, to: to, from: from, details: details as! String)
        

    }

}
