//
//  ScoreManager.swift
//  KeySpeed
//
//  Created by Grisha on 05/06/2016.
//  Copyright © 2016 Grisha. All rights reserved.
//

import UIKit
import GameKit
import AVFoundation
extension AVAudioPlayer {
    
    func tryToPlay() {
        
        if GameManager.isSoundOn() {
            self.play()
        }
    }
}


class GameManager: NSObject {
    class func setBestScore(score:Int) {

        if GameManager.currentBestScore() < score {
            
            NSUserDefaults.standardUserDefaults().setObject(score, forKey: "bestScore")

        }
        GameManager.submitBestScoreToGameCenter()

    }
    
    class func currentBestScore() -> Int {
        if let bestScore = NSUserDefaults.standardUserDefaults().objectForKey("bestScore") as? Int {
            return bestScore
        } else {
            return 0
        }
        
    }
    
    class func getTopMostViewController() -> UIViewController! {
        if var topController = UIApplication.sharedApplication().keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            return topController

            // topController should now be your topmost view controller
        } else {
            return nil
        }
    }
    class func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1 Show login if player is not logged in
                
                
                if let topController = GameManager.getTopMostViewController() {
                    
                    if topController.view.tag == 2 {
                        if let gVC = topController as? GameViewController {
                            if gVC.gameInstance.gameHasStarted {
                                gVC.pauseGamePressed()
                            }
                            
                            gVC.presentViewController(ViewController!, animated: true, completion: nil)
                        }
                    } else {
                        topController.presentViewController(ViewController!, animated: true, completion: nil)
                    }
                }

                
            } else if (localPlayer.authenticated) {
                // 2 Player is already euthenticated & logged in, load game center
                AppDelegate.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (leaderboardIdentifer: String?, error: NSError?) -> Void in
                    if error != nil {
                        GameManager.submitBestScoreToGameCenter()
                        print(error)
                    } else {
                        AppDelegate.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                })
                
                
            } else {
                // 3 Game center is not enabled on the users device
                AppDelegate.gcEnabled = false
                print("Local player could not be authenticated, disabling game center")
                print(error)
            }
            
        }
    }
    
        
    class func submitBestScoreToGameCenter() {
        
        let score = GameManager.currentBestScore()
        let leaderboardID = "defaultscore"
        let sScore = GKScore(leaderboardIdentifier: leaderboardID)
        sScore.value = Int64(score)
        
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        GKScore.reportScores([sScore], withCompletionHandler: { (error: NSError?) -> Void in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Score submitted")
                
            }
        })
    }
    
    class func isSoundOn() -> Bool {
        if let soundOn = NSUserDefaults.standardUserDefaults().valueForKey("soundOn") as? Bool {
            return soundOn
        } else {
            NSUserDefaults.standardUserDefaults().setObject(true, forKey: "soundOn")
            return true
        }
    }
    
    class func turnSoundOn() {
        NSUserDefaults.standardUserDefaults().setObject(true, forKey: "soundOn")
    }
    
    class func turnSoundOff() {
        NSUserDefaults.standardUserDefaults().setObject(false, forKey: "soundOn")
    }



//    class func deleteBestScore() {
//        if (self.currentNotificationToken() != nil) {
//            NSUserDefaults.standardUserDefaults().removeObjectForKey("notificationToken")
//        }
//    }
}
