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
    
    let itemsPerRow = 2
    let reuseIdentifier = "numberCell"
    let game = Game()
    
    var numCellsPerRow = 2
    var numArr = [Int]()
    var selectedCells = [Int]()
    var selectedTotal = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Quit", style: .plain, target: self, action: #selector(quitGame))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitButtonPressed))
        
        game.start()
        numArr = game.numArray
        title = game.generateNumberForTitle(numArray: numArr)
        
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
        
    }
    
    // UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! numberCell
        cell.numLabel.text = "\(numArr[indexPath.row])"
        
        if selectedCells.contains(indexPath.row) {
            cell.backgroundColor = UIColor.cyan
        } else {
            cell.backgroundColor = UIColor.yellow
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // flip animation or color change
        print("\(game.numArray[indexPath.row])")
        if selectedCells.contains(indexPath.row) {
            let index = selectedCells.index(of: indexPath.row)
            selectedTotal = selectedTotal - numArr[indexPath.row]
            selectedCells.remove(at: index!)
            print("Selected Total: \(selectedTotal)")
        } else {
            selectedCells.append(indexPath.row)
            selectedTotal = selectedTotal + numArr[indexPath.row]
            
            
            print("Selected Total: \(selectedTotal)")
        }
        
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewFlowLayout
    
    func setCollectionViewLayout(_ layout: UICollectionViewLayout, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        // call to animate changes in collectionview layout
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
