//
//  MainMenuViewController.swift
//  Numbojumbo
//
//  Created by Jason Eng on 7/3/17.
//  Copyright © 2017 EngJason. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    let buttonHeight: CGFloat = 35.0
    
    let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("P L A Y", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        
        return button
    }()
    
    let settingsButton: UIButton = {
        let button = UIButton()
        button.setTitle("S E T T I N G S", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 1.0, green: 0.4, blue: 1.0, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
        
        return button
    }()
    
    let aboutButton: UIButton = {
        let button = UIButton()
        button.setTitle("A B O U T", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(goToAbout), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(playButton)
        view.addSubview(settingsButton)
        view.addSubview(aboutButton)
        
        setUpPlayButton()
        setUpSettingsButton()
        setUpAboutButton()
    }

    func startGame() {
        print("Game started!")
        let gameVC = GameViewController()
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
    
    func goToSettings() {
        print("Settings opened!")
    }
    
    func goToAbout() {
        print("About page opened!")
    }
    
    func setUpPlayButton() {
        playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -35).isActive = true
        
        // how wide
        playButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
    }
    
    func setUpSettingsButton() {
        settingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        settingsButton.topAnchor.constraint(equalTo: playButton.centerYAnchor, constant: 35).isActive = true
        
        // how wide
        settingsButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
    }
    
    func setUpAboutButton() {
        aboutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        aboutButton.topAnchor.constraint(equalTo: settingsButton.centerYAnchor, constant: 35).isActive = true
        
        // how wide
        aboutButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        aboutButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
    }
}
