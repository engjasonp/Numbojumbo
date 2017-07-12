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
        self.layer.borderColor = UIColor.white.cgColor
        let game = Game()
        
        numLabel.text = String(describing: game.numArray.popLast())
    }

}
