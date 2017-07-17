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
    
    var numForTitle: String?
    var gameIsOver: Bool?
    var sum: Int?
    var level: Int?
    var score: Int?
    var numArr: [Int]?
    
    func start() {
        gameIsOver = false
        numArray = populateArrayWithRandomNums()
        level = 0
        score = 0
    }
    
    func populateArrayWithRandomNums() -> [Int] {
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
        return numArray
    }
    
    func generateNumberForTitle(numArray: [Int]) {
        // to be called when navbar loads
        // take sum of 2 nums from numArray
        numArr = numArray
        
        if numArr!.count > 1 {
            let randomIndexValue1 = Int(arc4random_uniform(UInt32(numArr!.count)))
            let num1 = numArr!.remove(at: randomIndexValue1)
            let randomIndexValue2 = Int(arc4random_uniform(UInt32(numArr!.count)))
            let num2 = numArr!.remove(at: randomIndexValue2)
            sum = num1 + num2
            numForTitle = String(sum!)
        } else if numArr!.count == 1 {
            sum = numArr![0]
            numForTitle = String(sum!)
        } else {
            nextLevel()
        }
    }
    
    func evaluateSubmission(num: Int) -> Bool {
        // code to be called when user pressed submitButton
        if num == sum {
            print("valid submission!")
            return true
        }
        return false
    }
    
    func nextLevel() {
        print("Level passed! Commence next level")
    }
}
