//
//  Game.swift
//  Numbojumbo
//
//  Created by Jason Eng on 7/11/17.
//  Copyright © 2017 EngJason. All rights reserved.
//

import Foundation

class Game {
    
    var numArray: [Int] = {
        let arr: [Int] = []
        return arr
    }()
    
    var level: Int
    var score: Int

    var numForTitle: String?
    
    var submissionIsValid: Bool
    var gameIsOver: Bool
    
    init() {
        self.level = 0
        self.score = 0
        self.gameIsOver = false
        self.submissionIsValid = false
    }
    
    func start() {
        populateArrayWithRandomNums()
    }
    
    func populateArrayWithRandomNums() {
        let totalSquares = 4
        for _ in 1...totalSquares {
            var randomNum = drand48() >= 0.5 ? Int(arc4random_uniform(51)) : (-1) * Int(arc4random_uniform(51))
            // while the number you come up with isn't in the array
            while numArray.contains(randomNum) {
                randomNum = drand48() >= 0.5 ? Int(arc4random_uniform(51)) : (-1) * Int(arc4random_uniform(51))
            }
            numArray.append(randomNum)
        }
        print(numArray)
    }
    
    func generateNumberForTitle() {
        // to be called when navbar loads
        // take sum of 2 nums from numArray
        
        if numArray.count > 1 {
            let randomIndexValue1 = Int(arc4random_uniform(UInt32(numArray.count)))
            let num1 = numArray.remove(at: randomIndexValue1)
            let randomIndexValue2 = Int(arc4random_uniform(UInt32(numArray.count)))
            let num2 = numArray.remove(at: randomIndexValue2)
            let sum = num1 + num2
            numForTitle = String(sum)
        } else if numArray.count == 1 {
            numForTitle = String(numArray[0])
        }
    }
    
    func evaluateSubmission(num: Int) {
        // code to be called when user pressed submitButton
        if num == Int(numForTitle!) {
            print("valid submission!")
            submissionIsValid = true
            if numArray.count == 0 {
                nextLevel()
            }
        } else {
            print("invalid submission!")
            submissionIsValid = false
        }
    }
    
    func nextLevel() {
        level = level + 1
    }
}
