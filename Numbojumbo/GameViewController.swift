//
//  GameViewController.swift
//  Numbojumbo
//
//  Created by Jason Eng on 7/3/17.
//  Copyright © 2017 EngJason. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    let containerView: UIView = {
        let bg = UIView()
        bg.backgroundColor = UIColor.black
        return bg
    }()
    
    let numCellsPerRow = 8
    
    var numArray: [Int] = {
        let arr: [Int] = []
        return arr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Quit", style: .plain, target: self, action: #selector(quitGame))
        
        setUpContainerView()
        
        let cellWidth = view.frame.width / CGFloat(numCellsPerRow)
        let numRows = Int(containerView.frame.height / cellWidth) - 2
        
        populateArrayWithRandomNums(rows: numRows, columns: numCellsPerRow)
        
        for row in 0..<numRows {
            for column in 0..<numCellsPerRow{
                // set up cell
                setUpCell(row: row, column: column, cellWidth: cellWidth)
                // display a random number in center of cell
                setUpCellLabel(row: row, column: column, cellWidth: cellWidth)
            }
        }
    }
    
    func setUpCell(row: Int, column: Int, cellWidth: CGFloat) {
        let cell = UIView()
        cell.backgroundColor = .blue
        cell.frame = CGRect(
            x: CGFloat(column) * cellWidth,
            y: CGFloat(row) * cellWidth,
            width: cellWidth,
            height: cellWidth
        )
        
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.white.cgColor
        
        view.addSubview(cell)
    }
    
    func setUpCellLabel(row: Int, column: Int, cellWidth: CGFloat) {
        let numLabel = UILabel()
        numLabel.frame = CGRect(
            x: (CGFloat(column) * cellWidth),
            y: (CGFloat(row) * cellWidth),
            width: cellWidth,
            height: cellWidth
        )
        
        numLabel.text = String(describing: numArray.popLast()!)//random number
        numLabel.font = UIFont.boldSystemFont(ofSize: 20)
        numLabel.textColor = .white
        numLabel.textAlignment = .center
        
        view.addSubview(numLabel)
    }
    
    func setUpContainerView() {
        containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(containerView)
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
    
    private func populateArrayWithRandomNums(rows: Int, columns: Int) {
        let totalSquares = rows * columns
        for _ in 0...totalSquares {
            // while the number you come up with isn't in the array
            var randomNum = Int(arc4random_uniform(150)) + 1
            while numArray.contains(randomNum) {
                randomNum = Int(arc4random_uniform(150)) + 1
            }
            numArray.append(randomNum)
        }
    }
        
    fileprivate func randomColor() -> UIColor {
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

