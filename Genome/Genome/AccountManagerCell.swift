//
//  AccountManagerCell.swift
//  Genome
//
//  Created by Egan Anderson on 4/19/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import UIKit

class AccountManagerCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var warningIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
