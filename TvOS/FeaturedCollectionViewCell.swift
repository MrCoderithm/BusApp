//
//  FeaturedCollectionViewCell.swift
//  w9TvApp
//
//  Created by Jawaad Sheikh on 2016-10-11.
//  Copyright © 2016 Jawaad Sheikh. All rights reserved.
//

import UIKit

class FeaturedCollectionViewCell: UICollectionViewCell {
    
    // Step 5a - create variables to hold image and city
    @IBOutlet var featuredImage: UIImageView!
    @IBOutlet var lblCity : UILabel!
    
    // Step 5b - create methods to define how cell looks
    // Use storyboard and also define reuse identifier
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    private func commonInit()
    {
        // Initialization code
        
        self.layoutIfNeeded()
        self.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    // used to highlight cell
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
     
        if (self.isFocused)
        {
            self.featuredImage.adjustsImageWhenAncestorFocused = true
        }
        else
        {
            self.featuredImage.adjustsImageWhenAncestorFocused = false
        }
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    
}
