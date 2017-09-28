//
//  LinkAccountsCell.swift
//  Genome
//
//  Created by Egan Anderson on 4/3/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import UIKit

class LinkAccountsCell: UITableViewCell {
    
    @IBOutlet var logoImage: UIImageView!
    
    var account: Account?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func formatCell() {
        if (account?.isUpToDate)! {
            logoImage.image = account?.imageColor
        } else {
            logoImage.image = account?.imageGray
        }
    }
    
}
