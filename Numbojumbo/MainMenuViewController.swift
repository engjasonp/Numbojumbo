//
//  MainMenuViewController.swift
//  Numbojumbo
//
//  Created by Jason Eng on 7/3/17.
//  Copyright © 2017 EngJason. All rights reserved.
//

import UIKit
import AVFoundation

class MainMenuViewController: UIViewController, GameVCDelegate {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet var aboutView: UIView!
    @IBOutlet var settingsView: UIView!
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
        
        setUpPlayButton()
        setUpSettingsButton()
        setUpAboutButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        playThemeSong()
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
        
        setUpSettingsView()
    }
    
    func setUpAboutButton() {
        aboutButton.translatesAutoresizingMaskIntoConstraints = false
        aboutButton.layer.cornerRadius = 10
        aboutButton.layer.masksToBounds = true
        aboutButton.layer.borderColor = UIColor.white.cgColor
        aboutButton.layer.borderWidth = 3.0
        
        setUpAboutView()
    }
    
    func setUpAboutView() {
        aboutView.layer.borderColor = UIColor.white.cgColor
        aboutView.layer.borderWidth = 2.0
        aboutView.layer.cornerRadius = 10
    }
    
    func setUpSettingsView() {
        settingsView.layer.borderColor = UIColor.white.cgColor
        settingsView.layer.borderWidth = 2.0
        settingsView.layer.cornerRadius = 10
        setUpVolumeSettings()
    }
    
    func playThemeSong() {
        guard let url = Bundle.main.url(forResource: "Talking With You", withExtension: "mp3") else {
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            mainMenuAudioPlayer = try AVAudioPlayer(contentsOf: url)
            guard let mainMenuAudioPlayer = mainMenuAudioPlayer else {
                return
            }
            mainMenuAudioPlayer.volume = Float(musicVolume / 100)
            mainMenuAudioPlayer.numberOfLoops = -1
            mainMenuAudioPlayer.play()
            print("playing")
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
    
    func gameViewControllerDidFinish(_ gameVC: GameViewController) {
        self.musicVolume = gameVC.musicVolume
        self.effectsVolume = gameVC.effectsVolume
        self.musicVolumeSwitch.isOn = gameVC.musicVolumeSwitch.isOn
        self.soundEffectsVolumeSwitch.isOn = gameVC.soundEffectsVolumeSwitch.isOn
        setUpVolumeSettings()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "playGame" {
            let gameVC = segue.destination as! GameViewController
            gameVC.delegate = self
            gameVC.musicVolume = self.musicVolume
            gameVC.effectsVolume = self.effectsVolume
            gameVC.musicVolumeSwitch.isOn = self.musicVolumeSwitch.isOn
            gameVC.soundEffectsVolumeSwitch.isOn = self.soundEffectsVolumeSwitch.isOn
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
    }
    
    @IBAction func musicVolumeChanged(_ sender: UISlider) {
        musicVolume = CGFloat(sender.value * 100)
        musicVolumeValueLabel.text = String(Int(musicVolume))
        mainMenuAudioPlayer.volume = Float(musicVolume / 100)
        musicVolumeSwitch.isOn = musicVolume > 0
    }
    
    @IBAction func soundEffectsVolumeChanged(_ sender: UISlider) {
        effectsVolume = CGFloat(sender.value * 100)
        soundEffectsVolumeValueLabel.text = String(Int(effectsVolume))
        soundEffectsVolumeSwitch.isOn = effectsVolume > 0
    }
    
    @IBAction func toggleMusicVolume(_ sender: UISwitch) {
        if musicVolumeSwitch.isOn {
            musicVolume = CGFloat(0)
            musicVolumeValueLabel.text = "0"
            musicVolumeSlider.value = 0
            mainMenuAudioPlayer.volume = musicVolumeSlider.value
            musicVolumeSwitch.setOn(false, animated: true)
        } else {
            musicVolumeSwitch.isOn = true
        }
    }
    
    @IBAction func toggleSoundEffectsVolume(_ sender: UISwitch) {
        if soundEffectsVolumeSwitch.isOn {
            effectsVolume = CGFloat(0)
            soundEffectsVolumeValueLabel.text = "0"
            soundEffectsVolumeSlider.value = 0
            soundEffectsVolumeSwitch.setOn(false, animated: true)
        } else {
            soundEffectsVolumeSwitch.isOn = true
        }
    }
}
