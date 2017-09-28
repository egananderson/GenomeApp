//
//  MusicCell.swift
//  Genome
//
//  Created by Egan Anderson on 4/20/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import UIKit

class MusicCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var artistAlbumLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var artistLabelConstraint: NSLayoutConstraint!
    @IBOutlet var timeLabelConstraint: NSLayoutConstraint!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
