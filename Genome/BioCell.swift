//
//  BioCell.swift
//  Genome
//
//  Created by Egan Anderson on 9/17/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import UIKit

class BioCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!    
    @IBOutlet var value: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
