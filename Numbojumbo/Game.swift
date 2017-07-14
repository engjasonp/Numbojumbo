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
    
//    var numForTitle: String?
    var gameIsOver: Bool?
    
    var level = 0
    var score = 0
    
    func start() {
        gameIsOver = false
        numArray = populateArrayWithRandomNums()
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
    
    func generateNumberForTitle(numArray: [Int]) -> String{
        // to be called when navbar loads
        // take sum of 2 nums from numArray
        var arr = numArray
        
        if arr.count > 1 {
            let randomIndexValue1 = Int(arc4random_uniform(UInt32(arr.count)))
            let num1 = arr.remove(at: randomIndexValue1)
            let randomIndexValue2 = Int(arc4random_uniform(UInt32(arr.count)))
            let num2 = arr.remove(at: randomIndexValue2)
            let sum = num1 + num2
            return String(sum)
        } else {
            return String(arr[0])
        }
    }
    
    func evaluateSubmission() {
        // code to be called when user pressed submitButton 
    }
    
    func nextLevel() {
        
    }
}
