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
    
    let game = Game()
    let reuseIdentifier = "numberCell"
    
    var itemsPerRow = Int()
    var selectedTotalValue = 0
    
    var numArr = [Int]()
    var selectedCells = [IndexPath]()
    var submittedCells = [IndexPath]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Quit", style: .plain, target: self, action: #selector(quitGame))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitButtonPressed))
        
        game.start() // populate the array with random nums
        numArr = game.numArray
        print("game.numArr: \(game.numArray)")
        itemsPerRow = game.numSquaresPerRow
        game.generateNumberForTitle()
        title = game.numForTitle
        
        let nib = UINib(nibName: "numberCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
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
    
    func submitButtonPressed() {
        print("self.numArr: \(numArr)")
        if String(selectedTotalValue) == title { // if you get a correct answer
            game.score = selectedCells.count
            // change selected cells to new color
            for i in 0..<selectedCells.count {
                if !submittedCells.contains(selectedCells[i]) {
                    submittedCells.append(selectedCells[i])
                }
            }
            
            print("game.score: \(game.score)")
            print("numArr.count: \(numArr.count)")
            
            print("game.level: \(game.level)")
            print("game.finalLevel: \(game.finalLevel)")
            
            if game.score == numArr.count { // if you passed a level
                
                selectedCells.removeAll()
                submittedCells.removeAll()
                
                if game.level < game.finalLevel {
                    // display "Correct!" message
                    let ac = UIAlertController(title: "Good job!", message: "Level passed! Commence next level.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    ac.addAction(okAction)
                    present(ac, animated: true, completion: nil)
                    
                    game.nextLevel()
                    print("game.level: \(game.level)")
                    numArr = game.numArray

                } else { // else you beat the whole game
                    let ac = UIAlertController(title: "Congrats!", message: "You beat the game! Try again?", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                        self.game.start()
                        self.collectionView.reloadData()
                    })
                    ac.addAction(okAction)
                    present(ac, animated: true, completion: nil)
                    return
                }
            }
            
            selectedTotalValue = 0
            
            game.generateNumberForTitle()
            title = game.numForTitle
            collectionView.reloadData()
            
        } else {
            // display "Incorrect!" message
            let ac = UIAlertController(title: "Incorrect!", message: "Submission invalid!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            ac.addAction(okAction)
            present(ac, animated: true, completion: nil)
            return
        }
        

        
        
        /*game.evaluateSubmission(num: selectedTotalValue)
        if game.submissionIsValid {
            for i in 0..<selectedCells.count {
                if !submittedCells.contains(selectedCells[i]) {
                    submittedCells.append(selectedCells[i])
                }
            }
            
            if game.level == 1 {
                let ac = UIAlertController(title: "Good job!", message: "Level passed! Commence next level.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                ac.addAction(okAction)
                present(ac, animated: true, completion: nil)
                
                numArr = game.numArray
                selectedCells.removeAll()
                submittedCells.removeAll()
                
                collectionView.reloadData()
            }
            
            else if game.level == 2 {
                let ac = UIAlertController(title: "Congrats!", message: "Level passed! You beat the game! Try again?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                    self.game.start()
                })
                ac.addAction(okAction)
                present(ac, animated: true, completion: nil)
            }
            
            selectedCells.removeAll()
            collectionView.reloadData()
            selectedTotalValue = 0
            
            print("level: \(game.level)")
            game.generateNumberForTitle()
            title = game.numForTitle
            
        } else {
            let ac = UIAlertController(title: "Incorrect!", message: "Submission invalid!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            ac.addAction(okAction)
            present(ac, animated: true, completion: nil)

        }*/
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
        
        if submittedCells.contains(indexPath) {
            cell.backgroundColor = UIColor.black
        }
        else if selectedCells.contains(indexPath) {
            cell.backgroundColor = UIColor.cyan
            
        } else {
            cell.backgroundColor = UIColor.yellow
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // flip animation or color change
        
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
        let width = collectionView.frame.size.width / CGFloat(itemsPerRow)
        let height = (self.view.frame.height) / CGFloat(itemsPerRow)
        
        return CGSize(width: width, height: height)
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
