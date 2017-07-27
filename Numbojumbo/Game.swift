//
//  Game.swift
//  Numbojumbo
//
//  Created by Jason Eng on 7/11/17.
//  Copyright © 2017 EngJason. All rights reserved.
//

import Foundation

class Game {
    
    var numArray: [Int]
    var numArrayCopy: [Int]
    var level: Int
    var finalLevel: Int
    var score: Int
    var numSquaresPerRow: Int
    
    var numForTitle: String?
    
    init() {
        self.level = 0
        self.finalLevel = 1
        self.score = 0
        self.numSquaresPerRow = 2
        self.numArray = []
        self.numArrayCopy = []
    }
    
    func start() {
        self.level = 0
        self.score = 0
        self.numSquaresPerRow = 2
        self.numArray = []
        self.numArrayCopy = []
        populateArrayWithRandomNums()
    }
    
    func populateArrayWithRandomNums() {
        // called when starting a level
        // creates populates an array with random numbers up until number of total squares
        
        numArray.removeAll()
        let totalSquares = Int(pow(Double((numSquaresPerRow)), 2.0))
        for _ in 0..<totalSquares {
            var randomNum = drand48() >= 0.5 ? Int(arc4random_uniform(51)) : (-1) * Int(arc4random_uniform(51))
            while numArray.contains(randomNum) || randomNum == 0 {
                randomNum = drand48() >= 0.5 ? Int(arc4random_uniform(51)) : (-1) * Int(arc4random_uniform(51))
            }
            numArray.append(randomNum)
        }
        print("game.numArray: \(numArray)")
        numArrayCopy = numArray
    }
    
    func generateNumberForTitle() {
        // called when navbar loads
        // called when submit button tapped
        // take sum of 2 nums from numArr unless there's only 1 number left
        
        print("numArrayCopy: \(numArrayCopy)")
        
        if numArrayCopy.count > 1 {
            let randomIndexValue1 = Int(arc4random_uniform(UInt32(numArrayCopy.count)))
            let num1 = numArrayCopy.remove(at: randomIndexValue1)
            let randomIndexValue2 = Int(arc4random_uniform(UInt32(numArrayCopy.count)))
            let num2 = numArrayCopy.remove(at: randomIndexValue2)
            print("num1: \(num1)")
            print("num2: \(num2)")
            let sum = num1 + num2
            numForTitle = String(sum)
        } else if numArrayCopy.count == 1 {
            numForTitle = String(numArrayCopy[0])
        }
    }
    
    func nextLevel() {
        numSquaresPerRow += 1
        populateArrayWithRandomNums()
        numArrayCopy = numArray
        level += 1
        score = 0
    }
}
