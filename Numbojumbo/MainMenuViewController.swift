//
//  MainMenuViewController.swift
//  Numbojumbo
//
//  Created by Jason Eng on 7/3/17.
//  Copyright © 2017 EngJason. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet var titleLabel: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        setUpTitleView()
        setUpPlayButton()
        setUpSettingsButton()
        setUpAboutButton()
    }
    
    func setUpTitleView() {
        for i in 0..<titleLabel.count {
            titleLabel[i].translatesAutoresizingMaskIntoConstraints = false
            titleLabel[i].layer.borderWidth = 3.0
            titleLabel[i].layer.borderColor = UIColor.black.cgColor
            if i % 2 == 0 {
                titleLabel[i].backgroundColor = UIColor(red: 0.702, green: 0.870, blue: 0.757, alpha: 1.0)
            }
        }
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.layer.cornerRadius = 10
        titleView.layer.masksToBounds = true
        titleView.layer.borderColor = UIColor.black.cgColor
        titleView.layer.borderWidth = 6.0
    }
    
    func setUpPlayButton() {
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.layer.cornerRadius = 10
        playButton.layer.masksToBounds = true
        playButton.layer.borderColor = UIColor.black.cgColor
        playButton.layer.borderWidth = 3.0
    }
    
    func setUpSettingsButton() {
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.layer.cornerRadius = 10
        settingsButton.layer.masksToBounds = true
        settingsButton.layer.borderColor = UIColor.black.cgColor
        settingsButton.layer.borderWidth = 3.0
    }
    
    func setUpAboutButton() {
        aboutButton.translatesAutoresizingMaskIntoConstraints = false
        aboutButton.layer.cornerRadius = 10
        aboutButton.layer.masksToBounds = true
        aboutButton.layer.borderColor = UIColor.black.cgColor
        aboutButton.layer.borderWidth = 3.0
    }
}
