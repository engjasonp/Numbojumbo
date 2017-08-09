//
//  MainMenuViewController.swift
//  Numbojumbo
//
//  Created by Jason Eng on 7/3/17.
//  Copyright © 2017 EngJason. All rights reserved.
//

import UIKit
import AVFoundation

class MainMenuViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet var aboutView: UIView!
    @IBOutlet var settingsView: UIView!
    @IBOutlet var titleLabel: [UILabel]!
    @IBOutlet weak var musicVolumeSwitch: UISwitch!
    @IBOutlet weak var musicVolumeSlider: UISlider!
    @IBOutlet weak var musicVolumeValueLabel: UILabel!
    @IBOutlet weak var soundEffectsVolumeSwitch: UISwitch!
    @IBOutlet weak var soundEffectsVolumeSlider: UISlider!
    @IBOutlet weak var soundEffectsVolumeValueLabel: UILabel!
    
    var effect: UIVisualEffect!
    var mainMenuAudioPlayer: AVAudioPlayer!
    var musicVolume: CGFloat = 0.0
    var effectsVolume: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        musicVolume = 10.0
        effectsVolume = 10.0
        
        setUpTitleView()
        setUpPlayButton()
        setUpSettingsButton()
        setUpAboutButton()
        
        playThemeSong()
    }
    
    func setUpTitleView() {
        for i in 0..<titleLabel.count {
            titleLabel[i].translatesAutoresizingMaskIntoConstraints = false
            titleLabel[i].layer.borderWidth = 3.0
            titleLabel[i].layer.borderColor = UIColor.white.cgColor
            if i % 2 == 0 {
                titleLabel[i].backgroundColor = UIColor(red: 0.563, green: 0.790, blue: 0.347, alpha: 1.0)
            }
        }
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.layer.cornerRadius = 20
        titleView.layer.masksToBounds = true
        titleView.layer.borderColor = UIColor.white.cgColor
        titleView.layer.borderWidth = 6.0
    }
    
    func setUpPlayButton() {
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.layer.cornerRadius = 10
        playButton.layer.masksToBounds = true
        playButton.layer.borderColor = UIColor.white.cgColor
        playButton.layer.borderWidth = 3.0
    }
    
    func setUpSettingsButton() {
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.layer.cornerRadius = 10
        settingsButton.layer.masksToBounds = true
        settingsButton.layer.borderColor = UIColor.white.cgColor
        settingsButton.layer.borderWidth = 3.0
    }
    
    func setUpAboutButton() {
        aboutButton.translatesAutoresizingMaskIntoConstraints = false
        aboutButton.layer.cornerRadius = 10
        aboutButton.layer.masksToBounds = true
        aboutButton.layer.borderColor = UIColor.white.cgColor
        aboutButton.layer.borderWidth = 3.0
    }
    
    func playThemeSong() {
        guard let url = Bundle.main.url(forResource: "soundName", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            mainMenuAudioPlayer = try AVAudioPlayer(contentsOf: url)
            guard let mainMenuAudioPlayer = mainMenuAudioPlayer else { return }
            
            mainMenuAudioPlayer.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func setUpVolumeSettings() {
        musicVolumeSlider.value = Float(musicVolume / 100)
        musicVolumeValueLabel.text = String(Int(musicVolumeSlider.value * 100))
        
        soundEffectsVolumeSlider.value = Float(effectsVolume / 100)
        soundEffectsVolumeValueLabel.text = String(Int(soundEffectsVolumeSlider.value * 100))
    }
    
    func animateIn(_ popUpView: UIView) {
        popUpView.center = self.view.center
        popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popUpView.alpha = 0
        self.view.addSubview(popUpView)
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            popUpView.alpha = 1
            popUpView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut(_ popUpView: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            popUpView.alpha = 0
            self.visualEffectView.effect = nil
        }) { (success: Bool) in
            popUpView.removeFromSuperview()
        }
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        mainMenuAudioPlayer.stop()
    }
    @IBAction func returnToMainMenuScreen(_ sender: UIButton) {
        animateOut(sender.superview!)
    }
    
    @IBAction func aboutButtonTapped(_ sender: UIButton) {
        animateIn(aboutView)
    }
    
    @IBAction func applySettingsChanges(_ sender: UIButton) {
        animateOut(sender.superview!)
    }
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        animateIn(settingsView)
        setUpVolumeSettings()
    }
    @IBAction func musicVolumeChanged(_ sender: UISlider) {
        musicVolumeValueLabel.text = String(Int(musicVolume))
        musicVolume = CGFloat(sender.value * 100)
    }
    @IBAction func soundEffectsVolumeChanged(_ sender: UISlider) {
        soundEffectsVolumeValueLabel.text = String(Int(effectsVolume))
        effectsVolume = CGFloat(sender.value * 100)
    }
}
