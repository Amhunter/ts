//
//  ViewController.swift
//  GGSachs
//
//  Created by Gumbat Abdullaev on 15.05.16.
//  Copyright © 2016 Gumbat Abdullaev. All rights reserved.
//

import UIKit
import GameKit
import AVFoundation

extension CGRect {
    func rightestX() -> CGFloat {
        return self.origin.x + self.width
    }
    func lowestY() -> CGFloat {
        return self.origin.y + self.height
    }
}


extension UIView {
    func pushTransition(duration:CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionPush
        animation.subtype = kCATransitionFromTop
        animation.duration = duration
        self.layer.addAnimation(animation, forKey: kCATransitionPush)
    }
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start ..< end)]
    }
}

protocol GameViewControllerDelegate {
    func didPressReturnToHome()
}

class GameViewController: UIViewController, UITextFieldDelegate, GameInstanceDelegate, GKGameCenterControllerDelegate {
    var textfield = UITextField()
    var leftLabel = UILabel()
    var leftFadeView = UIView()
    var rightLabel = UILabel()
    var rightFadeView = UIView()
    let leftFadeGradient: CAGradientLayer = CAGradientLayer()
    let rightFadeGradient: CAGradientLayer = CAGradientLayer()
    let gradientLength:CGFloat = 10
    var timerLabel = UILabel()
    var scoreLabel = KScoreLabel()
    var pauseButton = UIButton()
    var backgroundView = UIView()
    var backgroundImageView = UIImageView()
    let line = UIView()
    
    var delegate:GameViewControllerDelegate!
    var screenHeight = UIScreen.mainScreen().bounds.height
    var screenWidth = UIScreen.mainScreen().bounds.width
    
    var maxFitLength = 32
    
    var gameInstance = GameInstance()
    var speedometerView = SpeedometerView()
    var gameendview = GameEndView()
    var gamepauseview = GamePauseView()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.tag = 2
        // Set Screen background
        if UIDevice().userInterfaceIdiom == .Phone {
            switch UIScreen.mainScreen().nativeBounds.height {
            case 480:
                print("iPhone Classic")
            case 960:
                print("iPhone 4 or 4S")
            case 1136:
                backgroundImageView.image = UIImage(named: "background568")
                print("iPhone 5 or 5S or 5C")
            case 1334:
                backgroundImageView.image = UIImage(named: "background667")
                print("iPhone 6 or 6S")
            case 2208:
                print("iPhone 6+ or 6S+")
            default:
                print("unknown")
            }
        }
        backgroundImageView.backgroundColor = UIColor.blackColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(keyboardWillBeShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(appEnteredBackground(_:)),
            name: UIApplicationWillResignActiveNotification,
            object: UIApplication.sharedApplication())
        
        // Layout , self.view -> backgroundImageView -> backgroundView
        
        self.view.addSubview(self.backgroundImageView)
        self.backgroundImageView.frame.size = self.view.frame.size
        
        self.backgroundImageView.addSubview(self.backgroundView)
        self.backgroundView.frame.size = self.backgroundImageView.frame.size
        self.backgroundView.backgroundColor = UIColor.clearColor()
        
        self.backgroundView.addSubview(textfield)
        self.backgroundView.addSubview(leftLabel)
        self.backgroundView.addSubview(rightLabel)
        self.backgroundView.addSubview(timerLabel)
        self.backgroundView.addSubview(scoreLabel)
        self.backgroundView.addSubview(speedometerView)
        self.backgroundView.addSubview(pauseButton)

        textfield.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        speedometerView.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.translatesAutoresizingMaskIntoConstraints = false

        let views = [
            "textfield" : textfield,
            "timerLabel" : timerLabel,
            "scoreLabel" : scoreLabel,
            "speedometerView" : speedometerView,
            "pauseButton" : pauseButton
            
        ]
        let scale:CGFloat = screenHeight/667
        let pauseButtonSide:CGFloat = 55*scale
//        let bottomOffset:CGFloat = 61*scale
//        let replaySide:CGFloat = 94*scale
//        let textToButtonSpacing:CGFloat = 88*scale
//        let sideTextOffset:CGFloat = 70*scale
        let offset1:CGFloat = 15
        let ddda = screenWidth-(pauseButtonSide/2)-(offset1*2)
        // ---------screenwidth--------
        //
        
        
        let metrics = [
            "leftOffset": 11,
            "f1": offset1,
            "pauseButtonSide" : pauseButtonSide
//            "tw" : topOffset
        ]
//        let hConstraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10@999-[speedometerView]-10@999-|", options: [], metrics: metrics, views: views)
        let hConstraint0 = NSLayoutConstraint(item: speedometerView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.backgroundView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)

        let hConstraints1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[textfield]|", options: [], metrics: metrics, views: views)
        let hConstraints2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-f1@999-[scoreLabel]->=f1@999-[pauseButton(pauseButtonSide@999)]->=0@999-[timerLabel]-20@999-|", options: [NSLayoutFormatOptions.AlignAllBottom], metrics: metrics, views: views)
        let hConstraint3 = NSLayoutConstraint(item: pauseButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.backgroundView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        
        let vConstraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|->=50@999-[speedometerView]-0@999-[timerLabel(58@999)]-10@999-[textfield(42@999)]-0@999-|", options: [], metrics: metrics, views: views)
        let vConstraints1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-50@999-[speedometerView]-0@999-[scoreLabel(58@999)]-10@999-[textfield(42@999)]-0@999-|", options: [], metrics: metrics, views: views)
        let squareConstraint0 = NSLayoutConstraint(item: pauseButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: pauseButton, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        
        
        let imageSize = UIImage(named: "speedometer2x")!.size
        let imageWidth = imageSize.width
        let imageHeight = imageSize.height

//        let viewHeight = self.frame.height
//        
//        self.frame.size.width = (imageWidth/imageHeight)*viewHeight
        let propotion = (imageWidth/imageHeight)
        
        let speedometerConstraint0 = NSLayoutConstraint(item: speedometerView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: speedometerView, attribute: NSLayoutAttribute.Height, multiplier: propotion, constant: 0)
//        speedometerConstraint0.priority = 700
        let speedometerConstraint1 = NSLayoutConstraint(item: speedometerView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.backgroundView, attribute: NSLayoutAttribute.Top, multiplier: propotion, constant: -50)
        speedometerConstraint1.priority = 999
//        let speedometerConstraint2 = NSLayoutConstraint(item: speedometerView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: self.backgroundView, attribute: NSLayoutAttribute.Right, multiplier: propotion, constant: 0)
//        speedometerConstraint2.priority = 800

        
        self.backgroundView.addConstraints([[hConstraint0,speedometerConstraint0], hConstraints1, hConstraints2].flatMap{$0})
        self.backgroundView.addConstraint(hConstraint3)
        self.backgroundView.addConstraint(squareConstraint0)

        self.backgroundView.addConstraints(vConstraints0)
        self.backgroundView.addConstraints(vConstraints1)

        self.backgroundView.setNeedsLayout()
        self.backgroundView.layoutIfNeeded()
        self.navigationController?.navigationBarHidden = true
        line.backgroundColor = UIColor.blackColor()
        line.frame.size = CGSizeMake(1, textfield.frame.height)
        self.line.center = CGPointMake(textfield.frame.width/2-0.5,self.backgroundView.frame.height-(self.textfield.frame.height/2))
        self.backgroundView.addSubview(line)
        
        
        // Labels 
        scoreLabel.initializeLabel(40*scale)
        
        self.leftLabel.frame.size = CGSizeMake(self.screenWidth, self.textfield.frame.height)
        self.leftLabel.frame.origin = textfield.frame.origin
        self.leftLabel.numberOfLines = 1
        self.leftLabel.textAlignment = NSTextAlignment.Right
        self.leftLabel.textColor = ColorFromCode.colorWithHexString("#7F7F7F")
        self.leftLabel.font = UIFont(name: "Helvetica", size: 27)
        self.leftLabel.backgroundColor = ColorFromCode.colorWithHexString("#F2F2F2")
        
        self.rightLabel.frame.size = CGSizeMake(self.screenWidth, self.textfield.frame.height)
        self.rightLabel.frame.origin = CGPointMake(self.screenWidth-self.rightLabel.frame.width, self.backgroundView.frame.height-self.textfield.frame.height)
        self.rightLabel.numberOfLines = 1
        self.rightLabel.textAlignment = NSTextAlignment.Left
        self.rightLabel.textColor = UIColor.blackColor()
        self.rightLabel.font = UIFont(name: "Helvetica", size: 27)
        self.rightLabel.backgroundColor = UIColor.whiteColor()
        

        self.timerLabel.numberOfLines = 1
        self.timerLabel.textAlignment = NSTextAlignment.Right
        self.timerLabel.textColor = ColorFromCode.colorWithHexString("#F6FDFD")
        self.timerLabel.font = UIFont(name: "Helvetica", size: 36)
        
        rightLabel.text = gameInstance.textToType.substringToIndex(gameInstance.textToType.startIndex.advancedBy(maxFitLength/2))

        // Gradient Views
        self.backgroundView.addSubview(leftFadeView)
        self.leftFadeView.frame.size = CGSizeMake(gradientLength, self.textfield.frame.height)
        self.leftFadeView.frame.origin = textfield.frame.origin
        leftFadeGradient.frame = leftFadeView.bounds
        leftFadeGradient.colors = [ColorFromCode.colorWithHexString("#F2F2F2").CGColor, ColorFromCode.colorWithHexString("#F2F2F2").colorWithAlphaComponent(0).CGColor]
        self.leftFadeGradient.startPoint = CGPoint(x: 0,y: 0.5)
        self.leftFadeGradient.endPoint = CGPoint(x: 1,y: 0.5)
        self.leftFadeView.layer.insertSublayer(leftFadeGradient, atIndex: 0)
        
        self.backgroundView.addSubview(rightFadeView)
        self.rightFadeView.frame.size = CGSizeMake(gradientLength, self.textfield.frame.height)
        self.rightFadeView.frame.origin = CGPointMake(screenWidth-gradientLength,self.textfield.frame.origin.y)
        rightFadeGradient.frame = rightFadeView.bounds
        self.rightFadeGradient.startPoint = CGPoint(x: 0,y: 0.5)
        self.rightFadeGradient.endPoint = CGPoint(x: 1,y: 0.5)
        rightFadeGradient.colors = [UIColor.whiteColor().colorWithAlphaComponent(0).CGColor,UIColor.whiteColor().CGColor]
        self.rightFadeView.layer.insertSublayer(rightFadeGradient, atIndex: 0)
        
        self.pauseButton.setImage(UIImage(named: "Pause2x"), forState: UIControlState.Normal)
        self.pauseButton.addTarget(self, action: #selector(pauseGamePressed), forControlEvents: UIControlEvents.TouchUpInside)
        // Set Speedometer View
        speedometerView.setSpeedometer()

        textfield.hidden = true
        textfield.autocapitalizationType = UITextAutocapitalizationType.None
        textfield.becomeFirstResponder()
        textfield.delegate = self
        gameInstance.delegate = self
        updateTimerLabel(gameInstance.timerCount)
        updateCorrectLabel(0, mistakes: 0)
        self.backgroundImageView.userInteractionEnabled = true

        
        // Game End View
        self.view.addSubview(gameendview)
        gameendview.frame = self.view.frame
        gameendview.initializeView()
        gameendview.homeButton.addTarget(self, action: #selector(showHome), forControlEvents: UIControlEvents.TouchUpInside)
        gameendview.startAgainButton.addTarget(self, action: #selector(startAgain), forControlEvents: UIControlEvents.TouchUpInside)
        gameendview.gamecenterButton.addTarget(self, action: #selector(showLeaderboard), forControlEvents: UIControlEvents.TouchUpInside)

        
        // Game Pause View
        self.view.addSubview(gamepauseview)
        gamepauseview.frame = self.view.frame
        gamepauseview.initializeView()
        gamepauseview.homeButton.addTarget(self, action: #selector(showHome), forControlEvents: UIControlEvents.TouchUpInside)
        gamepauseview.resumeButton.addTarget(self, action: #selector(resumeGamePressed), forControlEvents: UIControlEvents.TouchUpInside)
        gamepauseview.replayButton.addTarget(self, action: #selector(replayGame), forControlEvents: UIControlEvents.TouchUpInside)

        
        


    }
    func appEnteredBackground(notification: NSNotification) {
        if gameInstance.gameHasStarted {
            gameInstance.pauseGame()
            speedometerView.pauseSpeedometer()
            showGamePauseView(true, animated: false)
        }

    }
    
    func pauseGamePressed() {
        gameInstance.pauseGame()
        speedometerView.pauseSpeedometer()
        showGamePauseView(true, animated: true)
    }
    
    func resumeGamePressed() {
        showGamePauseView(false, animated: true)
        gameInstance.resumeGame()
    }
    
    func showGameEndView(show:Bool) {
        show ? self.textfield.resignFirstResponder() : self.textfield.becomeFirstResponder()
        UIView.animateWithDuration(0.5) {
            self.gameendview.alpha = (show ? 1 : 0)
            self.gameendview.userInteractionEnabled = show
        }
    }
    
    func showGamePauseView(show:Bool,animated:Bool) {
        show ? self.textfield.resignFirstResponder() : self.textfield.becomeFirstResponder()
        UIView.animateWithDuration(animated ? 0.5 : 0) {
            self.gamepauseview.alpha = (show ? 1 : 0)
            self.gamepauseview.userInteractionEnabled = show
        }
    }
    
    func showHome() {
        
        if delegate != nil {
            delegate.didPressReturnToHome()
        }
    }
    
    
    func startAgain() { // from end view
        showGameEndView(false)
    }
    
    func replayGame() { // from pause view
        self.gameInstance.resetGame()
        showGamePauseView(false, animated: true)
    }
    
    // Text Functions
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        gameInstance.inputCharacter(string)
        return false
    }
    
    func mistakeTrigger() {
    }
    func correctTrigger() {
        
    }
    func shiftText() {
        //        var distance = gameInstance.textToType.startIndex.advan.distanceTo(gameInstance.textToType.endIndex)
        //        print("Distance to end \(distance)")
        let index = gameInstance.textToType.startIndex.advancedBy(gameInstance.currentCursor+maxFitLength/2, limit: gameInstance.textToType.endIndex)
        
        let reachedEnd = !(gameInstance.textToType.startIndex.distanceTo(index) >= 0 && index.distanceTo(gameInstance.textToType.endIndex) > 0)
        
        
//        print(reachedEnd)
        //
        //        if gameInstance.textToType.substringToIndex(gameInstance.textToType.endIndex) {
        //        print("Current Range \(index)")
        //        if index >= gameInstance.textToType.endIndex {
        //            index = gameInstance.textToType.endIndex
        //        }
        //
        //        var rg = gameInstance.textToType.startIndex.advancedBy(gameInstance.currentCursor)...gameInstance.textToType.endIndex
        //
        //        if let rightTextRange:Range<Index>? = gameInstance.textToType.startIndex.advancedBy(gameInstance.currentCursor)...index as? Range<Index> {
        //            rg = rightTextRange
        //            print("success")
        //        } else {
        //            print("fail")
        //        }
        //
        
        var numberOfLettersToDisplayOnTheLeft:Int!
        if gameInstance.currentCursor < maxFitLength/2 { // less than limit
            numberOfLettersToDisplayOnTheLeft = gameInstance.currentCursor
        } else {
            numberOfLettersToDisplayOnTheLeft = maxFitLength/2
        }
//        print("Number of Letters on the left \(numberOfLettersToDisplayOnTheLeft)")
        
        let leftTextRange = gameInstance.textToType.startIndex.advancedBy(gameInstance.currentCursor-(numberOfLettersToDisplayOnTheLeft))..<gameInstance.textToType.startIndex.advancedBy(gameInstance.currentCursor)
        
        //        print(leftTextRange)
        
        var rightText:String!
        if reachedEnd{
            rightText = gameInstance.textToType.substringFromIndex(gameInstance.textToType.startIndex.advancedBy(gameInstance.currentCursor))
        } else {
            let rightTextRange = gameInstance.textToType.startIndex.advancedBy(gameInstance.currentCursor)...index
            rightText = gameInstance.textToType.substringWithRange(rightTextRange)
        }
        
        
        let leftText = gameInstance.textToType.substringWithRange(leftTextRange).stringByAppendingString("\u{200c}")
        
        self.rightLabel.text = rightText
        self.leftLabel.text = leftText
    }
    func updateCorrectLabel(correct:Int, mistakes:Int) {
        ColorFromCode.colorWithHexString("#F6FDFD")
        
        


        let correctString = NSMutableAttributedString(string: "\(correct)", attributes:
            [NSFontAttributeName: UIFont(name: "Helvetica-Bold",size: 36)!,
                NSForegroundColorAttributeName : ColorFromCode.colorWithHexString("#D0F1F8")])
        
        let separatorString = NSAttributedString(string: " : ", attributes:
            [NSFontAttributeName: UIFont(name: "Helvetica-Bold",size: 36)!, NSForegroundColorAttributeName : ColorFromCode.colorWithHexString("#FFFFFF")])
        
        let mistakesString = NSMutableAttributedString(string: "\(mistakes)", attributes:
            [NSFontAttributeName: UIFont(name: "Helvetica-Bold",size: 36)!,
                NSForegroundColorAttributeName : ColorFromCode.colorWithHexString("#FFDCCB")])
        
        correctString.appendAttributedString(separatorString)
        correctString.appendAttributedString(mistakesString)

//        self.scoreLabel.attributedText = correctString
        
    }
    

    
    func updateTimerLabel(timeLeft:Double) {
        self.timerLabel.text = "\(Int(timeLeft))"
        
    }
    

    
    func keyboardShown(notification: NSNotification) {
        let info  = notification.userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
        
        let rawFrame = value.CGRectValue
        let keyboardFrame = view.convertRect(rawFrame, fromView: nil)

        
        //        var futurePostCommentViewframe:CGRect = CGRectMake(0, self.view.frame.height-self.PostCommentView.frame.height-movement, PostCommentView.frame.width, PostCommentView.frame.height)
        //        var futureTableViewframe:CGRect = CGRectMake(0, 0, self.view.frame.width,futurePostCommentViewframe.origin.y+self.navBarheight)
        //        println("\(futurePostCommentViewframe.origin.y)")
        

        print("keyboardFrame: \(keyboardFrame)")
    }
    
    var keyboardWasShownBefore = false
    
    func keyboardWillBeShown(notification: NSNotification) {
        let info  = notification.userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
        
        let rawFrame = value.CGRectValue
        let keyboardFrame = view.convertRect(rawFrame, fromView: nil)
        let animationDuration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.backgroundView.frame.size.height = self.view.frame.height - keyboardFrame.height
            self.backgroundView.layoutSubviews()

            self.line.center = CGPointMake(self.textfield.frame.width/2-0.5,self.backgroundView.frame.height-(self.textfield.frame.height/2))
            self.leftLabel.frame.origin = CGPointMake(-self.textfield.frame.width/2,self.textfield.frame.origin.y)
            self.rightLabel.frame.origin = CGPointMake(self.screenWidth-self.textfield.frame.width/2, self.textfield.frame.origin.y)

            self.leftFadeView.frame.origin = self.textfield.frame.origin
            self.rightFadeView.frame.origin = CGPointMake(self.screenWidth-self.gradientLength,self.textfield.frame.origin.y)
//            self.leftFadeGradient.frame = self.leftFadeView.bounds

//            self.leftFadeGradient.startPoint = CGPoint(x: 0,y: 0.5)
//            self.leftFadeGradient.endPoint = CGPoint(x: 1,y: 0.5)
            if !self.keyboardWasShownBefore {
                self.speedometerView.speedometerFrameWasUpdated()
            }

        }, completion: nil)
        keyboardWasShownBefore = true
        print("keyboardFrame: \(keyboardFrame)")
    }
    
    
    
    let nSeconds:Double = 7
    func timerValueWasUpdated(timerValue: Double) {
        updateTimerLabel(timerValue)
//        print(gameInstance.correctCount)
//        print(gameInstance.timeLimitForTheGame-timerValue)
        var lastSeconds = nSeconds
        
        if timerValue == 0 {
            return
        }
        
        var rightMargin:Double = (timerValue+nSeconds).roundToPlaces(1)
        
        if rightMargin > gameInstance.timeLimitForTheGame {
            rightMargin = gameInstance.timeLimitForTheGame
            lastSeconds = gameInstance.timeLimitForTheGame-timerValue
        }
//        print("Last seconds: \(lastSeconds)")
        let correctTimesInLastNSeconds = gameInstance.correctKeysTimestamps.filter {
            (value:Double) -> Bool in
            return value <= rightMargin
        }
        let speed = Double(correctTimesInLastNSeconds.count)/(lastSeconds)*60
//        print("Current Speed is \(speed)cpm")

        speedometerView.setSpeed(speed)
    }
    func gameHasEnded() {
        print("game has ended")
        let currentScore = gameInstance.correctCount - gameInstance.mistakesCount
        GameManager.setBestScore(currentScore)
        let bestScore = GameManager.currentBestScore()
        let speed:Int = gameInstance.correctCount/Int(round(gameInstance.timeLimitForTheGame))*60
        gameendview.showResult(currentScore, bestScore: bestScore, speed: speed)
        showGameEndView(true)
    }
    
    func gameWillStart() {
        print("game will start")
        speedometerView.animateStarting()
    }
    func gameWasReset() {
        print("game was reset")
//        updateCorrectLabel(0, mistakes: 0)
//        updateTimerLabel(gameInstance.timerCount)
        shiftText()
//        self.backgroundView.layoutSubviews()

    }
    
    func textHasShifted() {
        shiftText()
    }
    
    func correctCountHasChanged(correct: Int) {
        self.scoreLabel.updateCorrectLabel(correct)
    }
    
    func mistakesCountHasChanged(mistakes: Int) {
        self.scoreLabel.updateMistakesLabel(mistakes)
    }

    
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func showLeaderboard() {
        let gcVC: GKGameCenterViewController = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = GKGameCenterViewControllerState.Leaderboards
        gcVC.leaderboardIdentifier = "LeaderboardID"
        self.presentViewController(gcVC, animated: true, completion: nil)
    }
    
}

