//
//  ExperienceCell.swift
//  Genome
//
//  Created by Egan Anderson on 9/18/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import UIKit

class ExperienceCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var jobTitleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
