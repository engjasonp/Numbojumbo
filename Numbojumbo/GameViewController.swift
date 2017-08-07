//
//  GameViewController.swift
//  Numbojumbo
//
//  Created by Jason Eng on 7/3/17.
//  Copyright © 2017 EngJason. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var gameContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet var pauseMenuView: UIView!
    @IBOutlet weak var pauseMenuButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    let game = Game()
    let reuseIdentifier = "numberCell"
    
    var effect:UIVisualEffect!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        
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
                    ac.addAction(okAction)
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

    // pauseMenuView methods
    func animateIn() {
        
        pauseMenuView.center = gameContainerView.center
        pauseMenuView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        pauseMenuView.alpha = 0
        self.view.addSubview(pauseMenuView)
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.pauseMenuView.alpha = 1
            self.pauseMenuView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.pauseMenuView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.pauseMenuView.alpha = 0
            self.visualEffectView.effect = nil
        }) { (success: Bool) in
            self.pauseMenuView.removeFromSuperview()
        }
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
        
        if submittedCells.contains(indexPath) {
            cell.backgroundColor = UIColor(red: 0.702, green: 0.870, blue: 0.757, alpha: 1.0)
        }
        else if selectedCells.contains(indexPath) {
            cell.backgroundColor = UIColor(red: 1.0, green: 0.874, blue: 0, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.9, alpha: 1.0)
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
            let index = selectedCells.index(of: indexPath)
            selectedTotalValue = selectedTotalValue - game.numArray[indexPath.row]
            selectedCells.remove(at: index!)
        } else {
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
                    let ac = UIAlertController(title: "Congrats!", message: "You beat the game! Try again?", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                        self.reset()
                    })
                    ac.addAction(okAction)
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
        animateIn()
    }
    
    @IBAction func dismissPauseMenu(_ sender: UIButton) {
        collectionView.isUserInteractionEnabled = true
        submitButton.isUserInteractionEnabled = true
        pauseMenuButton.isUserInteractionEnabled = true
        animateOut()
        pauseMenuButton.setTitleColor(UIColor(red: 1.0, green: 0.874, blue: 0.0, alpha: 1.0), for: .normal)
        pauseMenuButton.setTitle("PAUSE", for: .normal)
        timerIsPaused = false
    }
    
    @IBAction func quitGame(_ sender: UIButton) {
        // present alert controller pop-up message
        let ac = UIAlertController(title: "", message: "Exit game?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            self.navigationController?.popToRootViewController(animated: true)
            print("Game quit!")
        })
        ac.addAction(okAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)

    }
    @IBAction func retry(_ sender: UIButton) {
        let ac = UIAlertController(title: "", message: "Try again?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            self.dismissPauseMenu(sender)
            self.reset()
        })
        ac.addAction(okAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
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
