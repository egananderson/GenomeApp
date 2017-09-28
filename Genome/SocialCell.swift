//
//  SocialCell.swift
//  Genome
//
//  Created by Egan Anderson on 9/18/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import UIKit

class SocialCell: UITableViewCell {

    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var detail1Label: UILabel!
    @IBOutlet var detail2Label: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
