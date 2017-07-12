//
//  GameViewController.swift
//  Numbojumbo
//
//  Created by Jason Eng on 7/3/17.
//  Copyright © 2017 EngJason. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
//    var statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
    
    @IBOutlet weak var gameContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var numCellsPerRow = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.edgesForExtendedLayout = []
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Quit", style: .plain, target: self, action: #selector(quitGame))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitButtonPressed))
        
        let nib = UINib(nibName: "numberCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
    }
    
    func handleTap(tap: UITapGestureRecognizer) {
        let location = tap.location(in: view)
        let width = gameContainerView.frame.width / CGFloat(numCellsPerRow)
        
        let i = Int(location.x / width)
        let j = Int(location.y / width)
        print(i, j)
    }
    
//    func setUpCell(row: Int, column: Int, cellWidth: CGFloat, cellHeight: CGFloat) {
//        let cell = UIView()
//        cell.backgroundColor = UIColor().randomColor() //.blue
//        cell.frame = CGRect(
//            x: CGFloat(column) * cellWidth,
//            y: CGFloat(row) * cellHeight,
//            width: cellWidth,
//            height: cellHeight
//        )
//        cell.layer.borderWidth = 0.5
//        cell.layer.borderColor = UIColor.white.cgColor
//        
//        gameContainerView.addSubview(cell)
//        setUpCellLabel(row: row, column: column, cellWidth: cellWidth, cellHeight: cellHeight)
//    }
//    
//    func setUpCellLabel(row: Int, column: Int, cellWidth: CGFloat, cellHeight: CGFloat) {
//        let numLabel = UILabel()
//        numLabel.frame = CGRect(
//            x: CGFloat(column) * cellWidth,
//            y: CGFloat(row) * cellHeight,
//            width: cellWidth,
//            height: cellHeight
//        )
//        
//        numLabel.text = String(describing: numArray.popLast()!)
//        numLabel.font = UIFont.boldSystemFont(ofSize: 20)
//        numLabel.textColor = .white
//        numLabel.textAlignment = .center
//        numLabel.isUserInteractionEnabled = true
//        numLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(printValue)))
//        
//        gameContainerView.addSubview(numLabel)
//    }
    
    func printValue(sender: UITapGestureRecognizer) {
        guard let a = (sender.view as? UILabel)?.text else {
            return
        }
        print(a)
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
    
    // UICollectionViewDelegate
    
    let itemsPerRow = 2
    let reuseIdentifier = "numberCell"
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = view.frame.width / CGFloat(itemsPerRow)
        let height = view.frame.height / CGFloat(itemsPerRow)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // flip animation or color change
        print("cell selected!")
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
