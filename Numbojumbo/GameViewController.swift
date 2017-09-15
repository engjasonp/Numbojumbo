//
//  GameViewController.swift
//  Numbojumbo
//
//  Created by Jason Eng on 7/3/17.
//  Copyright © 2017 EngJason. All rights reserved.
//

import UIKit
import AVFoundation

protocol GameVCDelegate: class {
    // Helps to pass the volume values from MainMenuViewController to GameViewController
    func gameViewControllerDidFinish (_ gameVC: GameViewController)
}
class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var gameContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet var pauseMenuView: UIView!
    @IBOutlet weak var pauseMenuButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!

    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var musicVolumeSwitch: UISwitch!
    @IBOutlet weak var soundEffectsVolumeSwitch: UISwitch!
    @IBOutlet weak var musicVolumeSlider: UISlider!
    @IBOutlet weak var soundEffectsVolumeSlider: UISlider!
    
    @IBOutlet weak var musicVolumeValueLabel: UILabel!
    @IBOutlet weak var soundEffectsVolumeValueLabel: UILabel!
    
    let game = Game()
    let reuseIdentifier = "numberCell"
    
    var itemsPerRow = Int()
    var selectedTotalValue = 0
    
    var numArr = [Int]()
    var selectedCells = [IndexPath]()
    var submittedCells = [IndexPath]()
    
    var timer = Timer()
    var timeRemaining = Int()
    var minutesLeft = Int()
    var secondsLeft = Int()
    var timerIsPaused = Bool()
    
    var effect:UIVisualEffect!
    var gameAudioPlayer: AVAudioPlayer!
    var effectsAudioPlayer: AVAudioPlayer!
    var musicVolume: CGFloat = 0.0
    var effectsVolume: CGFloat = 0.0
    
    var delegate: GameVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil

        playInGameSong()
        
        pauseMenuButton.tintColor = UIColor(red: 1.0, green: 0.874, blue: 0.0, alpha: 1.0)
        pauseMenuView.clipsToBounds = true
        pauseMenuView.layer.cornerRadius = 5
        
        reset()
        
        self.itemsPerRow = self.game.numSquaresPerRow
        
        let nib = UINib(nibName: "numberCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
    }
    
    func reset() {
        gameAudioPlayer.stop()
        gameAudioPlayer.play()
        timer.invalidate()
        game.start()
        timerIsPaused = false
        selectedTotalValue = 0
        selectedCells.removeAll()
        submittedCells.removeAll()
        
        self.timeRemaining = game.timeRemaining
        self.minutesLeft = game.minutesLeft
        self.secondsLeft = game.secondsLeft
        self.timerLabel.text = "\(self.minutesLeft):0\(self.secondsLeft)"

        self.title = game.generateNumberForTitle()
        self.numArr = game.numArray
        self.collectionView.reloadData()
        self.startTimer()
    }
    
    func startTimer() {
        self.setUpTimerLabel()
        self.timeRemaining -= 1
        self.setUpTimerLabel()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (Timer) in
            if !self.timerIsPaused {
                self.timeRemaining -= 1
                self.setUpTimerLabel()
                if self.timeRemaining < 0 {
                    self.timer.invalidate()
                    let ac = UIAlertController(title: "Times up!", message: "You lost the game! Try again?", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                        self.reset()
                    })
                    
                    let noAction = UIAlertAction(title: "NO", style: .default, handler: { (UIAlertAction) in
                        self.returnToMainMenu()
                    })
                    ac.addAction(okAction)
                    ac.addAction(noAction)
                    self.present(ac, animated: true, completion: nil)
                }
            }
        })
    }
    
    func setUpTimerLabel() {
        self.timerLabel.text = self.secondsLeft > 9 ? "\(self.minutesLeft):\(self.secondsLeft)" : "\(self.minutesLeft):0\(self.secondsLeft)"
        self.timerLabel.textColor = self.timeRemaining > 9 ? UIColor.white : UIColor.red
        self.minutesLeft = Int(self.timeRemaining) / 60 % 60
        self.secondsLeft = Int(self.timeRemaining) % 60
    }
    
    func playInGameSong() {
        guard let url = Bundle.main.url(forResource: "radiant-night", withExtension: "mp3") else {
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            gameAudioPlayer = try AVAudioPlayer(contentsOf: url)
            guard let gameAudioPlayer = gameAudioPlayer else {
                return
            }
            gameAudioPlayer.volume = Float(musicVolume / 100)
            gameAudioPlayer.numberOfLoops = -1
            gameAudioPlayer.play()
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
        popUpView.center = self.gameContainerView.center
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
    
    func returnToMainMenu() {
        self.gameAudioPlayer.stop()
        if self.delegate != nil {
            self.delegate?.gameViewControllerDidFinish(self)
        }
        self.navigationController?.popToRootViewController(animated: true)
        print("Game quit!")
    }
    
    // UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.numArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! numberCell
        cell.numLabel.text = "\(game.numArray[indexPath.row])"
        cell.numLabel.font = UIFont(name: "Arial", size: cell.frame.height / 3)
        cell.numLabel.textColor = .white
        
        if submittedCells.contains(indexPath) {
            cell.backgroundColor = UIColor(red: 0.875, green: 0.863, blue: 0.89, alpha: 1.0)
            cell.layer.borderColor = UIColor(red: 0.0, green: 0.082, blue: 0.078, alpha: 1.0).cgColor
        }
        else if selectedCells.contains(indexPath) {
            cell.backgroundColor = UIColor(red: 0.988, green: 0.29, blue: 0.102, alpha: 1.0)
            cell.layer.borderColor = UIColor.white.cgColor
        } else {
            cell.backgroundColor = UIColor(red: 0.988, green: 0.29, blue: 0.102, alpha: 1.0)
            cell.layer.borderColor = UIColor(red: 0.0, green: 0.082, blue: 0.078, alpha: 1.0).cgColor
            cell.layer.borderWidth = 9.0
        }
        
        if !selectedCells.isEmpty {
            submitButton.setTitleColor(UIColor(red: 1.0, green: 0.874, blue: 0, alpha: 1.0), for: .normal)
            submitButton.isUserInteractionEnabled = true
        } else {
            submitButton.setTitleColor(UIColor.darkGray, for: .normal)
            submitButton.isUserInteractionEnabled = false
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if submittedCells.contains(indexPath) {
            return
        }
        else if selectedCells.contains(indexPath) {
            playSoundEffect("blop", format: "mp3")
            let index = selectedCells.index(of: indexPath)
            selectedTotalValue = selectedTotalValue - game.numArray[indexPath.row]
            selectedCells.remove(at: index!)
        } else {
            playSoundEffect("pop", format: "mp3")
            selectedCells.append(indexPath)
            selectedTotalValue = selectedTotalValue + game.numArray[indexPath.row]
        }
        print("Selected Total: \(selectedTotalValue)")
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewFlowLayout
    
    func setCollectionViewLayout(_ layout: UICollectionViewLayout, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        // call to animate changes in collectionview layout
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        itemsPerRow = game.numSquaresPerRow
        let width = gameContainerView.frame.size.width / CGFloat(itemsPerRow)
        let height = gameContainerView.frame.height / CGFloat(itemsPerRow)
        
        return CGSize(width: width, height: height)
    }
    
    @IBAction func submit(_ sender: UIButton) {
        
        if selectedCells.isEmpty {
            return
        }
        
        if String(selectedTotalValue) == title {
            playSoundEffect("ding", format: "mp3")
            game.score += selectedCells.count
            
            // append selectedcells indexpaths to submittedcells
            for i in 0..<selectedCells.count {
                submittedCells.append(selectedCells[i])
                game.numArrayCopy.remove(at: game.numArrayCopy.index(of: game.numArray[selectedCells[i].row])!)
            }
            
            if game.score == numArr.count { // if you passed a level
                timer.invalidate()
                self.collectionView.reloadData()
                if game.currentLevel < game.finalLevel {
                    let ac = UIAlertController(title: "Good job!", message: "Level passed! Commence next level.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                        self.game.nextLevel()
                        self.timeRemaining += 61
                        self.startTimer()
                        self.numArr = self.game.numArray
                        self.selectedTotalValue = 0
                        self.title = self.game.generateNumberForTitle()
                        self.selectedCells.removeAll()
                        self.submittedCells.removeAll()
                        
                        self.collectionView.reloadData()
                    })
                    ac.addAction(okAction)
                    present(ac, animated: true, completion: nil)
                } else {
                    // else you beat the whole game
                    let timeRemaining = self.secondsLeft > 9 ? "\(self.minutesLeft):\(self.secondsLeft + 1)" : "\(self.minutesLeft):0\(self.secondsLeft + 1)"
                    let ac = UIAlertController(title: "Congrats!", message: "You beat the game with \(timeRemaining) remaining! Try again?", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
                        self.reset()
                    })
                    let noAction = UIAlertAction(title: "No", style: .default, handler: { (UIAlertAction) in
                        self.returnToMainMenu()
                    })
                    ac.addAction(okAction)
                    ac.addAction(noAction)
                    self.present(ac, animated: true, completion: nil)
                }                
                return
            }
            
            selectedTotalValue = 0
            self.selectedCells.removeAll()
            title = game.generateNumberForTitle()
            collectionView.reloadData()
            
        } else {
            // display "Incorrect!" message
            let ac = UIAlertController(title: "Incorrect!", message: "Submission invalid!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            ac.addAction(okAction)
            present(ac, animated: true, completion: nil)
        }
    }
    
    @IBAction func pauseMenuButtonClicked(_ sender: UIButton) {
        timerIsPaused = true
        pauseMenuButton.setTitleColor(UIColor.darkGray, for: .normal)
        pauseMenuButton.setTitle("PAUSED", for: .normal)
        pauseMenuButton.isUserInteractionEnabled = false
        collectionView.isUserInteractionEnabled = false
        submitButton.isUserInteractionEnabled = false
        animateIn(pauseMenuView)
    }
    
    @IBAction func dismissPauseMenu(_ sender: UIButton) {
        collectionView.isUserInteractionEnabled = true
        submitButton.isUserInteractionEnabled = true
        pauseMenuButton.isUserInteractionEnabled = true
        animateOut(pauseMenuView)
        pauseMenuButton.setTitleColor(UIColor(red: 1.0, green: 0.874, blue: 0.0, alpha: 1.0), for: .normal)
        pauseMenuButton.setTitle("PAUSE", for: .normal)
        timerIsPaused = false
    }
    
    @IBAction func quitGame(_ sender: UIButton) {
        // present alert controller pop-up message
        let ac = UIAlertController(title: "", message: "Exit game?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
            self.returnToMainMenu()
        })
        ac.addAction(okAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)

    }
    
    @IBAction func retry(_ sender: UIButton) {
        let ac = UIAlertController(title: "", message: "Try again?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
            self.dismissPauseMenu(sender)
            self.reset()
        })
        ac.addAction(okAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    @IBAction func settingsButtonClicked(_ sender: UIButton) {
        animateIn(settingsView)
        setUpVolumeSettings()
    }
    
    @IBAction func musicVolumeChanged(_ sender: UISlider) {
        musicVolume = CGFloat(sender.value * 100)
        musicVolumeValueLabel.text = String(Int(musicVolume))
        gameAudioPlayer.volume = Float(musicVolume / 100)
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
            gameAudioPlayer.volume = musicVolumeSlider.value
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
    
    @IBAction func applySettingsChanges(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.settingsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.settingsView.alpha = 0
        }) { (success: Bool) in
            self.settingsView.removeFromSuperview()
        }
    }
    
}

extension UIColor {
    func randomColor() -> UIColor {
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
