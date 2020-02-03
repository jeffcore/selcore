//
//  ListParticlesTableViewCell.swift
//  selcore
//
//  Created by Rix on 6/8/15.
//  Copyright (c) 2015 bitcore. All rights reserved.
//

import UIKit

class ListParticlesTableViewCell: UITableViewCell {

    @IBOutlet weak var particleNameLabel: UILabel!
    
    @IBOutlet weak var particleImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
