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
    
    var level = 0
    var score = 0
    
    func start() {
        gameIsOver = false
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
    
    func generateNumberForTitle(){
        // take sum of 2 nums from numArray
    }
    
    func evaluateSubmission() {
        // code to be called when user pressed submitButton 
    }
    
    func nextLevel() {
        
    }
}
