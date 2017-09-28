//
//  DataCategoryCellTableViewCell.swift
//  Genome
//
//  Created by Egan Anderson on 4/11/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import UIKit

class DataCategoryCellTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var arrowImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
