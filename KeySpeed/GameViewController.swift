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
    let line = UIView()
    
    var delegate:GameViewControllerDelegate!
    var screenHeight = UIScreen.mainScreen().bounds.height
    var screenWidth = UIScreen.mainScreen().bounds.width
    
    var maxFitLength = 32
    
    var gameInstance = GameInstance()
    var speedometerView = SpeedometerView()
    var gameendview = GameEndView()
    var gamepauseview = GamePauseView()

    let bannerSize:CGFloat = 50
    let imageSize = UIImage(named: "speedometer2x")!.size
    
    override func viewDidLoad() {
        super.viewDidLoad()
        maxFitLength = (UIDevice.currentDevice().userInterfaceIdiom == .Pad) ? 120 : 40
        // Do any additional setup after loading the view, typically from a nib.
        self.view.tag = 2
        
        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(keyboardWillBeShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(appEnteredBackground(_:)),
            name: UIApplicationWillResignActiveNotification,
            object: UIApplication.sharedApplication())

        self.view.addSubview(backgroundView)
        self.backgroundView.frame.size = self.view.frame.size
        
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
//        speedometerView.translatesAutoresizingMaskIntoConstraints = false
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
            "bannerSize": bannerSize,
            "pauseButtonSide" : pauseButtonSide
//            "tw" : topOffset
        ]

        let hConstraints1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[textfield]|", options: [], metrics: metrics, views: views)
        let hConstraints2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-f1@999-[scoreLabel]->=f1@999-[pauseButton(pauseButtonSide@999)]->=0@999-[timerLabel]-20@999-|", options: [NSLayoutFormatOptions.AlignAllBottom], metrics: metrics, views: views)
        let hConstraint3 = NSLayoutConstraint(item: pauseButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.backgroundView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        
        let vConstraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|->=bannerSize@999-[timerLabel(58@999)]-10@999-[textfield(42@999)]-0@999-|", options: [], metrics: metrics, views: views)
        let vConstraints1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|->=bannerSize@999-[scoreLabel(58@999)]-10@999-[textfield(42@999)]-0@999-|", options: [], metrics: metrics, views: views)
        let squareConstraint0 = NSLayoutConstraint(item: pauseButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: pauseButton, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        
        
        self.backgroundView.addConstraints([hConstraints1, hConstraints2].flatMap{$0})
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
        
        self.leftFadeView.frame.origin = self.textfield.frame.origin
        self.rightFadeView.frame.origin = CGPointMake(self.screenWidth-self.gradientLength,self.textfield.frame.origin.y)

        
        // Background Color
        let backgroundViewGradient = CAGradientLayer()
        backgroundViewGradient.frame = backgroundView.bounds
        backgroundViewGradient.startPoint = CGPoint(x: 0,y: 0)
        backgroundViewGradient.endPoint = CGPoint(x: 1,y: 1)
        backgroundViewGradient.colors = [ColorFromCode.colorWithHexString("#3F0C51").CGColor,ColorFromCode.colorWithHexString("#FF365D").CGColor]
        self.backgroundView.layer.insertSublayer(backgroundViewGradient, atIndex: 0)
        
        // Labels 
        scoreLabel.initializeLabel(40*scale)
        
        self.leftLabel.frame.size = CGSizeMake(self.screenWidth, self.textfield.frame.height)
        self.leftLabel.frame.origin = CGPointMake(-self.textfield.frame.width/2,self.textfield.frame.origin.y)
        self.leftLabel.numberOfLines = 1
        self.leftLabel.textAlignment = NSTextAlignment.Right
        self.leftLabel.textColor = ColorFromCode.colorWithHexString("#7F7F7F")
        self.leftLabel.font = UIFont(name: "Helvetica", size: 27)
        self.leftLabel.backgroundColor = ColorFromCode.colorWithHexString("#F2F2F2")
        
        self.rightLabel.frame.size = CGSizeMake(self.screenWidth, self.textfield.frame.height)
        self.rightLabel.frame.origin = CGPointMake(self.screenWidth-self.textfield.frame.width/2, self.textfield.frame.origin.y)
        self.rightLabel.numberOfLines = 1
        self.rightLabel.textAlignment = NSTextAlignment.Left
        self.rightLabel.textColor = UIColor.blackColor()
        self.rightLabel.font = UIFont(name: "Helvetica", size: 27)
        self.rightLabel.backgroundColor = UIColor.whiteColor()
        

        self.timerLabel.numberOfLines = 1
        self.timerLabel.textAlignment = NSTextAlignment.Right
        self.timerLabel.textColor = ColorFromCode.colorWithHexString("#F6FDFD")
        self.timerLabel.font = UIFont(name: "Helvetica", size: 36)
        

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
        self.setupSpeedometerFrame()

        textfield.hidden = true
        textfield.autocapitalizationType = UITextAutocapitalizationType.None
        textfield.becomeFirstResponder()
        textfield.delegate = self
        gameInstance.delegate = self
        updateTimerLabel(gameInstance.timerCount)
        updateCorrectLabel(0, mistakes: 0)

        
        // Game End View
        self.view.addSubview(gameendview)
        gameendview.frame = self.view.frame
        gameendview.initializeView()
        gameendview.homeButton.addTarget(self, action: #selector(showHome), forControlEvents: UIControlEvents.TouchUpInside)
        gameendview.replayButton.addTarget(self, action: #selector(startAgain), forControlEvents: UIControlEvents.TouchUpInside)
        gameendview.gameCenterButton.addTarget(self, action: #selector(showLeaderboard), forControlEvents: UIControlEvents.TouchUpInside)
        gameendview.shareButton.addTarget(self, action: #selector(self.share), forControlEvents: UIControlEvents.TouchUpInside)

        
        // Game Pause View
        self.view.addSubview(gamepauseview)
        gamepauseview.frame = self.view.frame
        gamepauseview.initializeView()
        gamepauseview.homeButton.addTarget(self, action: #selector(showHome), forControlEvents: UIControlEvents.TouchUpInside)
        gamepauseview.resumeButton.addTarget(self, action: #selector(resumeGamePressed), forControlEvents: UIControlEvents.TouchUpInside)
        gamepauseview.replayButton.addTarget(self, action: #selector(replayGame), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.gameInstance.resetGame()


    }
    
    func setupSpeedometerFrame() {
        

        var speedometerHeight = self.scoreLabel.frame.origin.y-bannerSize

        let imageWidth = imageSize.width
        let imageHeight = imageSize.height
        let proportion = (imageWidth/imageHeight)
        
        var speedometerWidth = proportion*speedometerHeight
        
        if speedometerWidth > screenWidth {
            speedometerWidth = screenWidth
            speedometerHeight = speedometerWidth/proportion
        }
        let leftOffset = (screenWidth-speedometerWidth)/2
        let topOffset = self.scoreLabel.frame.origin.y-speedometerHeight
        self.speedometerView.frame.size = CGSizeMake(speedometerWidth, speedometerHeight)
        let yCenter = topOffset+speedometerHeight/2
        self.speedometerView.center = CGPointMake(self.backgroundView.center.x, yCenter)
//        self.speedometerView.frame = CGRectMake(leftOffset, topOffset, speedometerWidth, speedometerHeight)
        self.speedometerView.speedometerFrameWasUpdated()

    }
    
    
    func appEnteredBackground(notification: NSNotification) {
        if gameInstance.gameHasStarted {
            gameInstance.pauseGame()
            speedometerView.pauseSpeedometer()
            showGamePauseView(true, animated: false)
        }

    }
    
    func pauseGamePressed() {
        SoundManager.clickSoundPlayer.tryToPlay()
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
        self.gameendview.animateButtons(show)
    }
    
    func showGamePauseView(show:Bool,animated:Bool) {
        show ? self.textfield.resignFirstResponder() : self.textfield.becomeFirstResponder()
        UIView.animateWithDuration(animated ? 0.5 : 0) {
            self.gamepauseview.alpha = (show ? 1 : 0)
            self.gamepauseview.userInteractionEnabled = show
        }
        self.gamepauseview.animateButtons(show)
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
        
        let autocompletionenabled = false
        if string.characters.count > 1 {
            if autocompletionenabled {
                return gameInstance.inputCharacter(string)
            } else {
                return false
            }
        } else {
            return gameInstance.inputCharacter(string)
        }
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
//        self.setupSpeedometerFrame()


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
            
            self.setupSpeedometerFrame()

        }, completion: nil)
        keyboardWasShownBefore = true
        print("keyboardFrame: \(keyboardFrame)")
    }
    
    
    
    let nSeconds:Double = 7
    var currentSpeed:Double = 0
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
        
        currentSpeed = Double(correctTimesInLastNSeconds.count)/(lastSeconds)*60
//        print("Current Speed is \(speed)cpm")

        speedometerView.setSpeed(currentSpeed)
    }
    func gameHasEnded() {
        print("game has ended")
        
        // get current score
        var currentScore = gameInstance.correctCount - gameInstance.mistakesCount
        if currentScore < 0 {
            currentScore = 0
        }
        
        // check for record
        let newRecord = currentScore > GameManager.currentBestScore() ? true : false

        // just a function, will not set if there is no new record
        GameManager.setBestScore(currentScore)
        
        // store best score anyway
        let bestScore = GameManager.currentBestScore()
        
        // calculate speed
        let speed:Int = Int(round(Double(gameInstance.correctCount)/gameInstance.timeLimitForTheGame*60))
        
        // show result
        gameendview.showResult(currentScore, bestScore: bestScore, speed: speed, newRecord: newRecord)
        showGameEndView(true)
    }
    
    func gameWillStart() {
        print("game will start")
        speedometerView.animateStarting()
    }
    func gameWasReset() {
        print("game was reset")
        currentSpeed = 0
        speedometerView.setSpeed(0)

        correctCountHasChanged(0)
        mistakesCountHasChanged(0)
        updateTimerLabel(gameInstance.timerCount)
        self.rightLabel.text = gameInstance.textToType.substringToIndex(gameInstance.textToType.startIndex.advancedBy(maxFitLength/2))
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
    func share() {
        
        //        let vc = self.view?.window?.rootViewController
        let image = GameManager.generateShareRecordImage()
        
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        //        activityVC.popoverPresentationController?.sourceView = self.view
        //        let rootFrame = (GameManager.getTopMostViewController() as! MainMenuViewController).shareButton.frame
        //        activityVC.popoverPresentationController?.sourceRect = CGRectMake(screenWidth/2, screenHeight/2, 1, 1)
        activityVC.completionWithItemsHandler = {
            (activityType: String?, completed: Bool,objects:[AnyObject]?, error:NSError?) -> Void in
            print("end")

        }
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
}

