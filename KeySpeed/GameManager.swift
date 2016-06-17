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
            // Uncomment
            self.play()
        }
    }
}


class GameManager: NSObject {
    
    class func randRangeToChooseText (lower: Int , upper: Int) -> Double {
        
        return Double(lower) + Double(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    class func renderUIViewToImage(viewToBeRendered:UIView?) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions((viewToBeRendered?.bounds.size)!, false, 0.0)
        viewToBeRendered!.drawViewHierarchyInRect(viewToBeRendered!.bounds, afterScreenUpdates: true)
        viewToBeRendered!.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage
    }
    
    class func generateShareRecordImage() -> UIImage {
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height
        
        let view = UIView()
        view.frame.size = CGSizeMake(screenWidth, screenWidth)
        
        let backgroundViewGradient = CAGradientLayer()
        backgroundViewGradient.frame = view.bounds
        backgroundViewGradient.startPoint = CGPoint(x: 0,y: 0)
        backgroundViewGradient.endPoint = CGPoint(x: 1,y: 1)
        backgroundViewGradient.colors = [ColorFromCode.colorWithHexString("#3F0C51").CGColor,ColorFromCode.colorWithHexString("#FF365D").CGColor]
        view.layer.insertSublayer(backgroundViewGradient, atIndex: 0)
        
        let scale:CGFloat = screenHeight/667
        
        
        let scoreLabel = UILabel()
        view.addSubview(scoreLabel)
        let scoreFont = UIFont(name: "Resamitz", size: 48*scale)
        scoreLabel.font = scoreFont
        scoreLabel.numberOfLines = 0
        scoreLabel.textColor = UIColor.whiteColor()
        scoreLabel.textAlignment = NSTextAlignment.Center
        scoreLabel.text = "\(GameManager.currentBestScore())"
        scoreLabel.sizeToFit()
        scoreLabel.center.y = view.center.y
        
        let textFont = UIFont(name: "Chalkboard SE", size: 26*scale)
        let attributedString = NSMutableAttributedString(string: "\(GameManager.currentBestScore())", attributes: [NSFontAttributeName: scoreFont!])
        attributedString.appendAttributedString(NSAttributedString(string: "\nI am a fast typer. Are you?", attributes: [NSFontAttributeName: textFont!]))
        
        scoreLabel.attributedText = attributedString
        scoreLabel.frame.size.width = screenWidth
        scoreLabel.frame.size.height = scoreLabel.sizeThatFits(CGSizeMake(screenWidth, CGFloat.max)).height
        let imageView = UIImageView()
        imageView.image = UIImage(named: "homeLogo")!
        let availableSpace = scoreLabel.frame.origin.y
        let spacingY = screenWidth*0.05
        let logoHeight = availableSpace*0.65
        let logoProportion:CGFloat = 223/160
        let logoWidth:CGFloat = logoProportion*logoHeight
        
        imageView.frame = CGRectMake(screenWidth/2-logoWidth/2, spacingY, logoWidth, logoHeight)
        view.addSubview(imageView)
        
        return GameManager.renderUIViewToImage(view)
        


        
        
    }
    
    
    class func randomAlphaNumericString(length: Int) -> String {
        
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.characters.count)
        var randomString = ""
        
        for _ in (0..<length) {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let newCharacter = allowedChars[allowedChars.startIndex.advancedBy(randomNum)]
            randomString += String(newCharacter)
        }
        
        return randomString
    }
    
    class func folderNameForLanguage(language:Language) -> String{
        switch language {
        case .English: return "englishTexts"
        case .Russian: return "englishTexts"
        case .Mandarin: return "englishTexts"
        case .Spanish:  return "englishTexts"
        case .Portuguese: return "englishTexts"
        case .Korean: return "englishTexts"
        case .Japanese: return "englishTexts"
        case .French: return "englishTexts"
        case .Italian:return "englishTexts"
        case .German: return "englishTexts"
        }
    }
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
