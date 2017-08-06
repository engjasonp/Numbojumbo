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
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Arial", size: 32.0)!, NSForegroundColorAttributeName: UIColor.white]
        title = "Numbojumbo"
        setUpPlayButton()
        setUpSettingsButton()
        setUpAboutButton()
    }
    
    func setUpPlayButton() {
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.layer.cornerRadius = 10
        playButton.layer.masksToBounds = true
        playButton.layer.borderColor = UIColor.black.cgColor
        playButton.layer.borderWidth = 2.0
    }
    
    func setUpSettingsButton() {
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.layer.cornerRadius = 10
        settingsButton.layer.masksToBounds = true
        settingsButton.layer.borderColor = UIColor.black.cgColor
        settingsButton.layer.borderWidth = 2.0
    }
    
    func setUpAboutButton() {
        aboutButton.translatesAutoresizingMaskIntoConstraints = false
        aboutButton.layer.cornerRadius = 10
        aboutButton.layer.masksToBounds = true
        aboutButton.layer.borderColor = UIColor.black.cgColor
        aboutButton.layer.borderWidth = 2.0
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        print("Game started!")
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        print("Settings opened!")
    }
    
    @IBAction func aboutButtonPressed(_ sender: UIButton) {
        print("About page opened!")
    }
}
