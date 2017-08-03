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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        let menuButton = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(quitGame))
        menuButton.tintColor = UIColor(red: 1.0, green: 0.874, blue: 0.0, alpha: 1.0)
        navigationItem.leftBarButtonItem = menuButton
        reset()
        
        self.itemsPerRow = self.game.numSquaresPerRow
        
        let nib = UINib(nibName: "numberCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
    }
    
    func reset() {
        game.start()
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
        //timer.fire()
        self.startTimer()
    }
    
    func startTimer() {
        self.timeRemaining -= 1
        self.setUpTimerLabel()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (Timer) in
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
        })
    }
    
    func setUpTimerLabel() {
        self.timerLabel.text = self.secondsLeft > 9 ? "\(self.minutesLeft):\(self.secondsLeft)" : "\(self.minutesLeft):0\(self.secondsLeft)"
        self.timerLabel.textColor = self.timeRemaining > 9 ? UIColor.white : UIColor.red
        self.minutesLeft = Int(self.timeRemaining) / 60 % 60
        self.secondsLeft = Int(self.timeRemaining) % 60
    }

    func launchMenu() {
        // present modal screen with Retry, Quit, and cancel options
    }
    
    func quitGame() {
        // present alert controller pop-up message
        let ac = UIAlertController()
        ac.addAction(UIAlertAction(title: "Exit game?", style: .default, handler: { action in
            self.navigationController?.popToRootViewController(animated: true)
            print("Game quit!")
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
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
            cell.layer.borderColor = nil
            cell.layer.borderWidth = 0.5
        }
        else if selectedCells.contains(indexPath) {
            cell.backgroundColor = UIColor(red: 0.791, green: 0.801, blue: 0.942, alpha: 1.0)
            cell.layer.borderColor = UIColor(red: 0.0, green: 0.082, blue: 0.078, alpha: 1.0).cgColor
            cell.layer.borderWidth = 9.0
        } else {
            cell.backgroundColor = UIColor(red: 0.791, green: 0.801, blue: 0.942, alpha: 1.0)
            cell.layer.borderColor = UIColor(red: 0.0, green: 0.082, blue: 0.078, alpha: 1.0).cgColor
            cell.layer.borderWidth = 0.5
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
            game.score = selectedCells.count
            // change selected cells to new color
            for i in 0..<selectedCells.count {
                if !submittedCells.contains(selectedCells[i]) {
                    submittedCells.append(selectedCells[i])
                    game.numArrayCopy.remove(at: game.numArrayCopy.index(of: game.numArray[selectedCells[i].row])!)
                }
            }
            print("game.score: \(game.score)")
            print("numArr.count: \(numArr.count)")
            print("game.currentLevel: \(game.currentLevel)")
            print("game.finalLevel: \(game.finalLevel)")
            
            if game.score == numArr.count { // if you passed a level
                timer.invalidate()
                collectionView.reloadData()
                selectedCells.removeAll()
                submittedCells.removeAll()
                
                if game.currentLevel < game.finalLevel {
                    // display "Correct!" message
                    print("data reloaded")
                    let ac = UIAlertController(title: "Good job!", message: "Level passed! Commence next level.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                        self.game.nextLevel()
                        self.timeRemaining += 60
                        self.startTimer()
                        
                        print("game.currentLevel: \(self.game.currentLevel)")
                        
                        //self.setUpTimerLabel()
                        self.numArr = self.game.numArray
                        
                        self.selectedTotalValue = 0
                        print("Selected Total: \(self.selectedTotalValue)")
                        
                        self.title = self.game.generateNumberForTitle()
                        print("data reloaded")
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
            print("Selected Total: \(selectedTotalValue)")
            
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
}

extension UIColor {
    func randomColor() -> UIColor {
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
