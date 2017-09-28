//
//  SectionHeaderView.swift
//  Genome
//
//  Created by Egan Anderson on 4/20/17.
//  Copyright © 2017 Egan Anderson. All rights reserved.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var buttonImageView: UIImageView!
    @IBOutlet var button: UIButton!
    
    override func awakeFromNib() {
        let blackPlus = UIImage(named: "plus")
        buttonImageView.image = blackPlus?.imageWithColor(color: UIColor.white)
        buttonImageView.isHidden = true
        button.isHidden = true
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        
    }


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
