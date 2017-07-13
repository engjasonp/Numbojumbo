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

        self.backgroundColor = UIColor.green
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.black.cgColor
        numLabel.textColor = UIColor.red
    }
    
    func toggleSelectedState() {
        if isSelected {
            print("Selected!")
            self.contentView.backgroundColor = UIColor.white
            self.backgroundColor = UIColor.blue
            print("background color is white")
        } else {
            self.contentView.backgroundColor = UIColor.green
            self.backgroundColor = UIColor.red
            print("Deselected!")
        }
    }

}
