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
        
        setUpPlayButton()
        setUpSettingsButton()
        setUpAboutButton()
    }
    
    func setUpPlayButton() {
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.layer.cornerRadius = 5
        playButton.layer.masksToBounds = true
    }
    
    func setUpSettingsButton() {
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.layer.cornerRadius = 5
        settingsButton.layer.masksToBounds = true
        
    }
    
    func setUpAboutButton() {
        aboutButton.translatesAutoresizingMaskIntoConstraints = false
        aboutButton.layer.cornerRadius = 5
        aboutButton.layer.masksToBounds = true
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
