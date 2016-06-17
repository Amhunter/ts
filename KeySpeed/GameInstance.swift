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

    var timeLimitForTheGame:Double = 5
    var timerCount:Double = 0
    
    var gameHasStarted = false
    var gameIsPaused = false

    
    var timer:Timer!

    override init() {
        super.init()
        timer = Timer(interval: 0.1, delegate: self)
        
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
    func inputCharacter(character:String) -> Bool { // pressed character will be here, true if pass, false if not
        
        if gameIsPaused{ // ignore input if paused
            return false
        }
        
        if currentCursor >= textToType.characters.count { // ignore if end
            return false
        }
        
        
        let pressedChar = character
        
        if pressedChar == "\n" { // ignore enter key
            return false
        }
        
        if pressedChar == "" { // ignore delete key
            return false
        }
        
        let compareRange = textToType.startIndex.advancedBy(currentCursor)...textToType.startIndex.advancedBy(currentCursor+character.characters.count-1)
        let textt = textToType.substringWithRange(compareRange)
        
        if pressedChar == textToType.substringWithRange(compareRange) {
            
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
            return true

        } else {
            if currentCursor > 0 {
                
                mistakesCount += 1
                SoundManager.mistakeSoundPlayer.tryToPlay()

                if delegate != nil {
                    delegate!.mistakeTrigger()
                    delegate!.mistakesCountHasChanged(mistakesCount)
                }
            }
            return false
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
        
        let randomInt = "\(Int(GameManager.randRangeToChooseText(1, upper: 500)))"
        do {
            let chosenlanguage = AppDelegate.chosenLanguage.rawValue as NSString
            let fileName = "\(chosenlanguage.substringToIndex(3))\(randomInt)"
//            print(NSBundle.mainBundle().resourcePath)
            let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "txt")
            textToType = try String(contentsOfFile: path!,encoding: NSUTF8StringEncoding)
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

        } catch {
            let aVC = UIAlertController(title: "Error", message: "\(error)", preferredStyle: UIAlertControllerStyle.Alert)
            aVC.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            GameManager.getTopMostViewController().presentViewController(aVC, animated: true, completion: nil)
        }

        
        
        
        

    }
}
