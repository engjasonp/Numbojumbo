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
    var currentLevel: Int
    var finalLevel: Int
    var score: Int
    var numSquaresPerRow: Int
    
    var timeRemaining = 60
    var minutesLeft = 1
    var secondsLeft = 0
    
    init() {
        self.currentLevel = 0
        self.finalLevel = 4
        self.score = 0
        self.numSquaresPerRow = 4
        self.numArray = []
        self.numArrayCopy = []
    }
    
    func start() {
        self.currentLevel = 0
        self.score = 0
        self.numSquaresPerRow = 2
        self.numArray = []
        self.numArrayCopy = []
        populateArrayWithRandomNums()
    }
    
    func populateArrayWithRandomNums() {
        // called when starting a new level
        // creates populates an array with non-zero random numbers up until number of total squares
        numArray.removeAll()
        let totalSquares = numSquaresPerRow * numSquaresPerRow
        for _ in 0..<totalSquares {
            var randomNum = drand48() >= 0.5 ? Int(arc4random_uniform(UInt32(10))) : (-1) * Int(arc4random_uniform(UInt32(10)))
            while randomNum == 0 {
                randomNum = drand48() >= 0.5 ? Int(arc4random_uniform(UInt32(10))) : (-1) * Int(arc4random_uniform(UInt32(10)))
            }
            numArray.append(randomNum)
        }
        print("game.numArray: \(numArray)")
        numArrayCopy = numArray
    }
    
    func generateNumberForTitle() -> String {
        var result = 0
        var indexArr = [Int]()
        
        var randomNum = Int(arc4random_uniform(UInt32(currentLevel + 3)))
        print("randomNum: \(randomNum)")
        while randomNum > numArrayCopy.count || randomNum == 0 {
            randomNum = Int(arc4random_uniform(UInt32(currentLevel + 3)))
        }
        print("randomNum: \(randomNum)")
        for _ in 0..<randomNum {
            var randomIndexValue = Int(arc4random_uniform(UInt32(numArrayCopy.count)))
            while indexArr.contains(randomIndexValue) {
                randomIndexValue = Int(arc4random_uniform(UInt32(numArrayCopy.count)))
            }
            indexArr.append(randomIndexValue)
            let num = numArrayCopy[numArrayCopy.index(randomIndexValue, offsetBy: 0)]
            result += num
        }
        
        return String(result)
        
//        if numArrayCopy.count > 1 {
//            let randomIndexValue1 = Int(arc4random_uniform(UInt32(numArrayCopy.count)))
//            let num1 = numArrayCopy[numArrayCopy.index(randomIndexValue1, offsetBy: 0)]
//            var randomIndexValue2 = Int(arc4random_uniform(UInt32(numArrayCopy.count)))
//            while randomIndexValue2 == randomIndexValue1 {
//                randomIndexValue2 = Int(arc4random_uniform(UInt32(numArrayCopy.count)))
//            }
//            let num2 = numArrayCopy[numArrayCopy.index(randomIndexValue2, offsetBy: 0)]
//            
//            print("num1: \(num1)")
//            print("num2: \(num2)")
//            
//            let sum = num1 + num2
//            return String(sum)
//        } else if numArrayCopy.count == 1 {
//            return String(numArrayCopy[0])
//        }
//            return ""
    }
    
    func nextLevel() {
        numSquaresPerRow += 1
        populateArrayWithRandomNums()
        numArrayCopy = numArray
        currentLevel += 1
        score = 0
    }
}
