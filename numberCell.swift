//
//  numberCell.swift
//  Numbojumbo
//
//  Created by Jason Eng on 7/11/17.
//  Copyright © 2017 EngJason. All rights reserved.
//

import UIKit

class numberCell: UICollectionViewCell {
    
    @IBOutlet weak var numLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        numLabel.textColor = UIColor(red: 0.0, green: 0.082, blue: 0.078, alpha: 1.0)
    }

}
