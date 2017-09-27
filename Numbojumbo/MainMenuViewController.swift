//
//  MainMenuViewController.swift
//  Numbojumbo
//
//  Created by Jason Eng on 7/3/17.
//  Copyright © 2017 EngJason. All rights reserved.
//

import UIKit
import AVFoundation

class MainMenuViewController: UIViewController, UIScrollViewDelegate, GameVCDelegate {
    
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
    @IBOutlet weak var aboutScrollView: UIScrollView!
    @IBOutlet weak var howToPlayLabel: UILabel!
    @IBOutlet weak var aboutTitleSeparatorView: UIView!
    @IBOutlet weak var okButtonSeparatorView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var applyChangesButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var effect: UIVisualEffect!
    var mainMenuAudioPlayer: AVAudioPlayer!
    var effectsAudioPlayer: AVAudioPlayer!
    var musicVolume: CGFloat = 0.0
    var effectsVolume: CGFloat = 0.0
    
    var navigationBarHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarHeight = self.navigationController!.navigationBar.frame.height
        
        aboutScrollView.delegate = self
        let slides: [Slide] = createSlides()
        setupSlideScrollView(slides: slides)
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        aboutView.bringSubview(toFront: pageControl)
        
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
    
    func createSlides() -> [Slide] {
        let slide1: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide1.textView.text = "• Try to beat the game before the time runs out!\n\n•Select at least one (1) square to add up to the sum at the top of the screen. \n\n• Tap \"SUBMIT\" after selected. \n\n• You can move on to the next level once all squares are cleared. \n\n• If you pass a level, you are given an extension of 60 seconds. \n\n• Good luck!"
        
        let slide2: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide2.textView.text = "Song credits: \n\nTalking With You by Artificial.Music https://soundcloud.com/artificial-music \nCreative Commons — Attribution 3.0 Unported— CC BY 3.0 \nhttps://creativecommons.org/licenses/by/3.0/ \nMusic provided by Audio Library https://youtu.be/NAgcAg0pW6w \n\nRadiant Night by Sappheiros \nhttps://soundcloud.com/sappheirosmusic \nCreative Commons — Attribution 3.0 Unported— CC BY 3.0 \nhttps://creativecommons.org/licenses/by/3.0/"
        
        return [slide1, slide2]
    }
    
    func setupSlideScrollView(slides:[Slide]) {
        
        let scrollViewHeight = aboutView.frame.height - (howToPlayLabel.frame.height + aboutTitleSeparatorView.frame.height + okButtonSeparatorView.frame.height + okButton.frame.height)
        
        aboutScrollView.frame = CGRect(x: aboutView.frame.minX, y: aboutTitleSeparatorView.frame.maxY, width: aboutView.frame.width, height: scrollViewHeight)
        aboutScrollView.contentSize = CGSize(width: aboutView.frame.width * CGFloat(slides.count), height: scrollViewHeight)
        aboutScrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: aboutView.frame.width * CGFloat(i), y: 0, width: aboutView.frame.width, height: scrollViewHeight)
            aboutScrollView.addSubview(slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageIndex = round(scrollView.contentOffset.x/aboutView.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
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
        okButton.layer.cornerRadius = 10
    }
    
    func setUpSettingsView() {
        settingsView.layer.borderColor = UIColor.white.cgColor
        settingsView.layer.borderWidth = 2.0
        settingsView.layer.cornerRadius = 10
        setUpVolumeSettings()
        
        applyChangesButton.layer.cornerRadius = 10
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
    
    func playSoundEffect(_ title: String, format: String) {
        guard let url = Bundle.main.url(forResource: title, withExtension: format) else {
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            effectsAudioPlayer = try AVAudioPlayer(contentsOf: url)
            guard let effectsAudioPlayer = effectsAudioPlayer else {
                return
            }
            effectsAudioPlayer.volume = Float(effectsVolume / 100)
            effectsAudioPlayer.play()
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
        popUpView.center = CGPoint(x: self.view.center.x, y: (self.view.frame.height + navigationBarHeight)/2)
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
        playSoundEffect("blop", format: "mp3")
        mainMenuAudioPlayer.stop()
    }
    
    @IBAction func returnToMainMenuScreen(_ sender: UIButton) {
        playSoundEffect("blop", format: "mp3")
        animateOut(sender.superview!)
    }
    
    @IBAction func aboutButtonTapped(_ sender: UIButton) {
        playSoundEffect("blop", format: "mp3")
        animateIn(aboutView)
    }
    
    @IBAction func applySettingsChanges(_ sender: UIButton) {
        playSoundEffect("blop", format: "mp3")
        animateOut(sender.superview!)
    }
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        playSoundEffect("blop", format: "mp3")
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
