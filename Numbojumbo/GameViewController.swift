//
//  GameViewController.swift
//  Numbojumbo
//
//  Created by Jason Eng on 7/3/17.
//  Copyright © 2017 EngJason. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    var statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
    var navBarHeight: CGFloat?
    
    let containerView: UIView = {
        let bg = UIView()
        bg.backgroundColor = UIColor.black
        return bg
    }()
    
    var numCellsPerRow = 2
    
    var numArray: [Int] = {
        let arr: [Int] = []
        return arr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarHeight = self.navigationController!.navigationBar.frame.height
        
        self.edgesForExtendedLayout = []
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Quit", style: .plain, target: self, action: #selector(quitGame))
        
        generateNumberTitle()
        setUpContainerView()
        
        let cellWidth = containerView.frame.width / CGFloat(numCellsPerRow)
        
        let cellHeight = containerView.frame.height / CGFloat(numCellsPerRow)
        
        let numRows = numCellsPerRow    // Int(containerView.frame.height / cellWidth)
        
        populateArrayWithRandomNums(rows: numRows, columns: numCellsPerRow)
        
        for row in 0..<numRows {
            for column in 0..<numCellsPerRow{
                // set up cell
                setUpCell(row: row, column: column, cellWidth: cellWidth, cellHeight: cellHeight)
                // display a random number in center of cell
                //setUpCellLabel(row: row, column: column, cellWidth: cellWidth)
            }
        }
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    func generateNumberTitle(){
        title = "52"
    }
    
    func setUpContainerView() {
        // change height to be view.frame.height - navbar
        let viewHeight = view.frame.height
        containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: viewHeight - navBarHeight! - statusBarHeight)
        view.addSubview(containerView)
    }
    
    func handleTap(tap: UITapGestureRecognizer) {
        let location = tap.location(in: view)
        let width = containerView.frame.width / CGFloat(numCellsPerRow)
        
        let i = Int(location.x / width)
        let j = Int(location.y / width)
        print(i, j)
    }
    
    func setUpCell(row: Int, column: Int, cellWidth: CGFloat, cellHeight: CGFloat) {
        let cell = UIView()
        cell.backgroundColor = UIColor().randomColor() //.blue
        cell.frame = CGRect(
            x: CGFloat(column) * cellWidth,
            y: CGFloat(row) * cellHeight,
            width: cellWidth,
            height: cellHeight
        )
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.white.cgColor
        
        containerView.addSubview(cell)
        setUpCellLabel(row: row, column: column, cellWidth: cellWidth, cellHeight: cellHeight)
    }
    
    func setUpCellLabel(row: Int, column: Int, cellWidth: CGFloat, cellHeight: CGFloat) {
        let numLabel = UILabel()
        numLabel.frame = CGRect(
            x: CGFloat(column) * cellWidth,
            y: CGFloat(row) * cellHeight,
            width: cellWidth,
            height: cellHeight
        )
        
        numLabel.text = String(describing: numArray.popLast()!)
        numLabel.font = UIFont.boldSystemFont(ofSize: 20)
        numLabel.textColor = .white
        numLabel.textAlignment = .center
        numLabel.isUserInteractionEnabled = true
        numLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(printValue)))
        
        containerView.addSubview(numLabel)
    }
    
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
    
    private func populateArrayWithRandomNums(rows: Int, columns: Int) {
        let totalSquares = rows * columns
        for _ in 1...totalSquares {
            // while the number you come up with isn't in the array
            var randomNum = Int(arc4random_uniform(150)) + 1
            while numArray.contains(randomNum) {
                randomNum = Int(arc4random_uniform(150)) + 1
            }
            numArray.append(randomNum)
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
