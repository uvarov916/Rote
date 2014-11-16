//
//  CustomTableViewCell.swift
//  Rote
//
//  Created by Aleksander Skjølsvik on 15.11.14.
//  Copyright (c) 2014 Rote Inc. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet var questionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
