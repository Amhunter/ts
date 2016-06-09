//
//  GameManager.swift
//  KeySpeed
//
//  Created by Grisha on 18/05/2016.
//  Copyright © 2016 Grisha. All rights reserved.
//

import UIKit
import AVFoundation

enum GameMode:Int {
    case PureText = 0
    case Letters = 1
    case Numbers = 2

}
protocol GameInstanceDelegate {
    func timerValueWasUpdated(timerValue:Double)
    func gameHasEnded()
    func gameWasReset()
    func gameWillStart()
    func mistakeTrigger()
    func correctTrigger()
    func correctCountHasChanged(correct:Int)
    func mistakesCountHasChanged(mistakes:Int)
    func textHasShifted()

}

class GameInstance: NSObject,TimerDelegate {
    
    var gameMode:GameMode!
    var delegate:GameInstanceDelegate!
    
    var textToType = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    
    var currentCursor:Int = 0
    var mistakesCount:Int = 0
    var correctCount:Int = 0
    var correctKeysTimestamps:[Double] = []

    var timeLimitForTheGame:Double = 40
    var timerCount:Double = 0
    
    var gameHasStarted = false
    var gameIsPaused = false

    
    var timer:Timer!
    var mistakeSoundPlayer:AVAudioPlayer!

    override init() {
        super.init()
        timer = Timer(interval: 0.1, delegate: self)
        
        // Sounds
        let wrongTypeSoundURL = NSBundle.mainBundle().URLForResource("wrong-type", withExtension: "wav")
        do {
            try mistakeSoundPlayer = AVAudioPlayer(contentsOfURL: wrongTypeSoundURL!)
            
        } catch let error {
            print(error)
        }
    }
    
    
    // Timer Delegate Methods
    func timerDidFire(timer: Timer) {
        if !gameHasStarted {
            return
        }
        decrementTimerCount()
    }
    func timerWillResume(timer: Timer) {
        
    }
    func timerWillStart(timer: Timer) {
        
    }
    func timerDidPause(timer: Timer) {
        
    }
    func timerDidStop(timer: Timer) {
        
    }
    
    // Game Methods
    func decrementTimerCount() {
        timerCount -= 0.1
        timerCount = timerCount.roundToPlaces(1)
//        print(timerCount)
        if timerCount <= 0.0 {
            endGame()
        } else {
            if delegate != nil {
                delegate!.timerValueWasUpdated(timerCount)
            }
        }
    }
    func startGame() {
        if delegate != nil {
            delegate!.gameWillStart()
        }
        self.timerCount = timeLimitForTheGame
        timer.start(nil)
        gameHasStarted = true
        
    }
    func endGame() {
        if delegate != nil {
            delegate!.gameHasEnded()
        }
        gameHasStarted = false
        resetGame()
    }
    func inputCharacter(character:String) { // pressed character will be here
        
        if gameIsPaused{ // ignore input if paused
            return
        }
        
        if currentCursor >= textToType.characters.count {
            return
        }
        
        let pressedChar = character
        
        if pressedChar == "\n" { // ignore enter key
            return
        }
        
        if pressedChar == textToType[currentCursor] {
            
            if currentCursor == 0 { // start game
                startGame()
            }
            
            currentCursor += 1
            correctKeysTimestamps.append(timerCount)
            
            correctCount += 1
            //            print("Current Cursor is \(currentCursor)")
            
            if delegate != nil {
                delegate!.correctCountHasChanged(correctCount)
                delegate!.textHasShifted()
            }
            

        } else {
            if currentCursor > 0 {
                
                mistakesCount += 1
                mistakeSoundPlayer.tryToPlay()

                if delegate != nil {
                    delegate!.mistakeTrigger()
                    delegate!.mistakesCountHasChanged(mistakesCount)
                }
                
                
            }
        }
        

        //updateCorrectLabel(correctCount, mistakes: mistakesCount)
    }
    func pauseGame() {
        gameIsPaused = true

        timer.pause()
        print("Game was paused")
    }
    func resumeGame() {
        gameIsPaused = false
        if gameHasStarted {
            timer.resume()
        }

    
//        timer.
    }
    func resetGame() {
        gameIsPaused = false
        gameHasStarted = false
        timer.stop()
        timerCount = timeLimitForTheGame
        
//        if delegate != nil {
//            delegate!.timerValueWasUpdated(timerCount)
//        }
        
        mistakesCount = 0
        correctCount = 0
        currentCursor = 0
        correctKeysTimestamps = []
        if delegate != nil {
            delegate!.gameWasReset()
        }
        

    }
}
