//
//  ProgramTableViewCell.swift
//  w9WatchConnectivity
//
//  Created by Ali Muhammad on 2019-11-04.
//  Copyright © 2019 Ali Muhammad. All rights reserved.
//

import UIKit

class ProgramTableViewCell: UITableViewCell {
    
    @IBOutlet var title : UILabel!
    @IBOutlet var speaker : UILabel!
    @IBOutlet var imgSpeaker : UIImageView!
    @IBOutlet var from : UILabel!
    @IBOutlet var to : UILabel!
    
    @IBAction func saveSelection(sender : UIButton)
    {
        print("saved")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
