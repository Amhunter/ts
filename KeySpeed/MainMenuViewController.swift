//
//  MainMenuViewController.swift
//  KeySpeed
//
//  Created by Grisha on 19/05/2016.
//  Copyright © 2016 Grisha. All rights reserved.
//

import UIKit
import GameKit
import AVFoundation

class MainMenuViewController: UIViewController,GameViewControllerDelegate,GKGameCenterControllerDelegate {
    
    let screenHeight = UIScreen.mainScreen().bounds.height
    let screenWidth = UIScreen.mainScreen().bounds.width
    
    var backgroundView = UIView()
    var logoImageView = UIImageView()
    var buttonsSuperview = UIView()
    let recordScoreLabel = UILabel()
    var playButton = ExpandButton()
    var languageButton = ExpandButton()
    var shareButton = ExpandButton()
    var soundOnOffButton = ExpandButton()
    var gameCenterButton = ExpandButton()
    let initiallySoundOn = true
    var animationIsPaused = false
    var animationIsAlreadyActive = false // to ignore animateRain() if already active
    var spawnedViews:[UIView] = []
    
    
    // Initial Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubviews()
        customizeViews()
        spawnInitialViews()
        // Sounds
        soundOnOffButton.selected = GameManager.isSoundOn()
        
    }
    func setSubviews() {
        
        self.logoImageView.image = UIImage(named: "homeLogo")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        self.logoImageView.tintColor = UIColor.whiteColor()
        
        self.view.addSubview(backgroundView)
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        let v = [
            "backgroundView": backgroundView
        ]
        
        let h1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[backgroundView]|", options: [], metrics: nil, views: v)
        let v1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[backgroundView]|", options: [], metrics: nil, views: v)
        self.view.addConstraints([h1,v1].flatMap{$0})
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        // Subviews
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        recordScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonsSuperview.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundView.addSubview(logoImageView)
        self.backgroundView.addSubview(recordScoreLabel)
        self.backgroundView.addSubview(playButton)
        self.backgroundView.addSubview(buttonsSuperview)
        let scale:CGFloat = screenHeight/667
        let views = [
            "logo" : logoImageView,
            "recordScoreLabel" : recordScoreLabel,
            "playButton" : playButton,
            "buttonsSuperview" : buttonsSuperview
        ]
        
        let playButtonSize:CGFloat = 124*scale
        let logoWidth:CGFloat = (UIDevice.currentDevice().userInterfaceIdiom == .Pad) ? 240 : screenWidth
        let logoProportion:CGFloat = 223/160
        let logoHeight = logoWidth/logoProportion
        let logoTopOffset:CGFloat =  (UIDevice.currentDevice().userInterfaceIdiom == .Pad) ? 0 : 33*scale
        let buttonsTopOffset:CGFloat = 102*scale
        let playButtonTopOffset:CGFloat = 85*scale
        let logoOffset:CGFloat = (UIDevice.currentDevice().userInterfaceIdiom == .Pad) ? 150 : 76*scale
        let metrics = [
            "logoOffset": logoOffset,
            "playButtonSize": playButtonSize,
            "logoHeight": logoHeight,
            "logoTopOffset": logoTopOffset,
            "buttonsTopOffset": buttonsTopOffset,
            "playButtonTopOffset": playButtonTopOffset
        ]
        
        //        let ratioConstraint = NSLayoutConstraint(item: logoImageView, attribute: .Height, relatedBy: .Equal, toItem: logoImageView, attribute: .Width, multiplier: (logoImageView.image!.size.height / logoImageView.image!.size.width), constant: 0)
        
        let hConstraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-logoOffset@999-[logo]-logoOffset@999-|", options: [], metrics: metrics, views: views)
        let hConstraint1 = NSLayoutConstraint(item: playButton, attribute: .CenterX, relatedBy: .Equal, toItem: backgroundView, attribute: .CenterX, multiplier: 1, constant: 0)
        let hConstraint2 = NSLayoutConstraint(item: buttonsSuperview, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: backgroundView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let hConstraint3 = NSLayoutConstraint(item: logoImageView, attribute: .Height, relatedBy: .Equal, toItem: logoImageView, attribute: .Width, multiplier:1/logoProportion, constant: 0)
        let hConstraint4 = NSLayoutConstraint(item: recordScoreLabel, attribute: .CenterX, relatedBy: .Equal, toItem: backgroundView, attribute: .CenterX, multiplier: 1, constant: 0)
        
        let squareConstraint0 = NSLayoutConstraint(item: playButton, attribute: .Height, relatedBy: .Equal, toItem: playButton, attribute: .Width, multiplier: 1, constant: 0)
        
        
        
        let vConstraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-logoTopOffset@999-[logo][recordScoreLabel(playButtonTopOffset@999)][playButton(playButtonSize@999)]-buttonsTopOffset@500-[buttonsSuperview]->=60@999-|", options: [], metrics: metrics, views: views)
        
        self.backgroundView.addConstraints([hConstraints0, vConstraints0,[hConstraint1,hConstraint2,hConstraint3,hConstraint4,squareConstraint0]].flatMap{$0})
        
        //        self.menuBackgroundView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        
        self.backgroundView.userInteractionEnabled = true
        
        // Menu Subviews
        // Buttons Superview
        buttonsSuperview.addSubview(gameCenterButton)
        buttonsSuperview.addSubview(soundOnOffButton)
        buttonsSuperview.addSubview(shareButton)
        buttonsSuperview.addSubview(languageButton)
        
        self.gameCenterButton.translatesAutoresizingMaskIntoConstraints = false
        self.soundOnOffButton.translatesAutoresizingMaskIntoConstraints = false
        self.shareButton.translatesAutoresizingMaskIntoConstraints = false
        self.languageButton.translatesAutoresizingMaskIntoConstraints = false
        
        let sbviews = [
            "gamecenterButton" : gameCenterButton,
            "shareButton" : shareButton,
            "languageButton" : languageButton,
            "soundButton" : soundOnOffButton
        ]
        
        let sbmetrics = [
            "btnSize": 63*scale,
            "btnSpc": 30*scale
        ]
        
        let shConstraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[soundButton(==btnSize@999)]-btnSpc@999-[gamecenterButton(==btnSize@999)]-btnSpc@999-[shareButton(==btnSize@999)]-btnSpc@999-[languageButton(==btnSize@999)]|", options: [NSLayoutFormatOptions.AlignAllCenterY,NSLayoutFormatOptions.AlignAllTop,NSLayoutFormatOptions.AlignAllBottom], metrics: sbmetrics, views: sbviews)
        
        let shConstraint1 = NSLayoutConstraint(item: gameCenterButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: gameCenterButton, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        let shConstraint2 = NSLayoutConstraint(item: shareButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: shareButton, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        let shConstraint3 = NSLayoutConstraint(item: soundOnOffButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: soundOnOffButton, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        let shConstraint4 = NSLayoutConstraint(item: languageButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: languageButton, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        let svConstraints5 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[shareButton]|", options: [], metrics: metrics, views: sbviews)
        
        buttonsSuperview.addConstraints([[shConstraint1,shConstraint2,shConstraint3,shConstraint4],shConstraints0, svConstraints5].flatMap({$0}))
        
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        self.initialLogoCenter = logoImageView.center.x
    }
    func customizeViews() {
        let scale:CGFloat = screenHeight/667
        //        let fontName1 = "Chalkboard SE"
        //        let fontName2 = "Avenir Next Condensed"
        //        let firstLine = NSMutableAttributedString(string: "text\n", attributes: [NSFontAttributeName:UIFont(name: fontName1,size: 54*scale)!])
        //        let secondLine = NSAttributedString(string: "SPEED",attributes: [NSFontAttributeName:UIFont(name: fontName2, size:98*scale)!])
        //        firstLine.appendAttributedString(secondLine)
        //        self.logoImageView.numberOfLines = 2
        //        self.logoImageView.textAlignment = NSTextAlignment.Center
        //        self.logoImageView.textColor = UIColor.whiteColor()
        //        self.logoImageView.attributedText = firstLine
        self.recordScoreLabel.text = "Best Score: \(GameManager.currentBestScore())"
        self.recordScoreLabel.textColor = UIColor.whiteColor()
        self.recordScoreLabel.font = UIFont(name: "Resamitz", size: 24*scale)
        
        self.playButton.setImage(UIImage(named: "homePlay2x"), forState: UIControlState.Normal)
        self.playButton.backgroundColor = ColorFromCode.colorWithHexString("#3F0C51")
        self.playButton.layer.cornerRadius = self.playButton.frame.width/2
        self.playButton.addTarget(self, action: #selector(play), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.languageButton.setImage(UIImage(named: "homeLanguage2x"), forState: UIControlState.Normal)
        self.languageButton.backgroundColor = ColorFromCode.colorWithHexString("#55106E")
        self.languageButton.layer.cornerRadius = self.languageButton.frame.width/2
        self.languageButton.addTarget(self, action: #selector(animateRain), forControlEvents: UIControlEvents.TouchUpInside)
        self.shareButton.setImage(UIImage(named: "homeShare2x"), forState: UIControlState.Normal)
        self.shareButton.backgroundColor = ColorFromCode.colorWithHexString("#55106E")
        self.shareButton.layer.cornerRadius = self.shareButton.frame.width/2
        self.shareButton.addTarget(self, action: #selector(share), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        gameCenterButton.setImage(UIImage(named: "homeGamecenter"), forState: UIControlState.Normal)
        gameCenterButton.addTarget(self, action: #selector(openGameCenter), forControlEvents: UIControlEvents.TouchUpInside)
        gameCenterButton.layer.cornerRadius = gameCenterButton.frame.width/2
        gameCenterButton.backgroundColor = ColorFromCode.colorWithHexString("#55106E")
        
        soundOnOffButton.addTarget(self, action: #selector(soundOnOff(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        soundOnOffButton.disableSound = true
        soundOnOffButton.selected = GameManager.isSoundOn()
        soundOnOffButton.setImage(UIImage(named: "homeSoundOn"), forState: UIControlState.Selected)
        soundOnOffButton.setImage(UIImage(named: "homeSoundOff"), forState: UIControlState.Normal)
        soundOnOffButton.backgroundColor = ColorFromCode.colorWithHexString("#55106E")
        soundOnOffButton.layer.cornerRadius = soundOnOffButton.frame.width/2
        
        let backgroundViewGradient = CAGradientLayer()
        backgroundViewGradient.frame = backgroundView.bounds
        backgroundViewGradient.startPoint = CGPoint(x: 0,y: 0)
        backgroundViewGradient.endPoint = CGPoint(x: 1,y: 1)
        backgroundViewGradient.colors = [ColorFromCode.colorWithHexString("#3F0C51").CGColor,ColorFromCode.colorWithHexString("#FF365D").CGColor]
        self.backgroundView.layer.insertSublayer(backgroundViewGradient, atIndex: 0)
        
        logoImageView.backgroundColor = UIColor.clearColor()
        buttonsSuperview.backgroundColor = UIColor.clearColor()
    }
    func spawnInitialViews() {
        for i in 1...6 {
            
            // Calculate Parameters
            let screenPortion = (screenHeight-self.logoImageView.frame.lowestY())/3
            let initialYFactor:Int = ((i-1)/2) // will be either 1,2 or 3
            let yRandomOffset = CGFloat(GameManager.randRangeToChooseText(0, upper:10)-5)
            let initialY:CGFloat = self.logoImageView.frame.lowestY()+10+(CGFloat(initialYFactor)*screenPortion)+yRandomOffset
            
            let min:CGFloat = (UIDevice.currentDevice().userInterfaceIdiom == .Pad) ? 47 : 32
            let max:CGFloat = (UIDevice.currentDevice().userInterfaceIdiom == .Pad) ? 88 : 51
            let sideSize:CGFloat = CGFloat(GameManager.randRangeToChooseText(Int(min), upper: Int(max)))
            
            var initialX:Double!
            var upperLimit:CGFloat!
            
            if i % 2 == 0 {
                upperLimit = screenWidth/2
                initialX = GameManager.randRangeToChooseText(10, upper: Int(upperLimit)-Int(sideSize))
            } else {
                upperLimit = screenWidth
                let lowerLimit = screenWidth/2
                initialX = GameManager.randRangeToChooseText(Int(lowerLimit), upper: Int(upperLimit)-10-Int(sideSize))
            }

            // Create View
            let keyView:UILabel! = UILabel()
            keyView.layer.cornerRadius = 4
            keyView.layer.borderColor = UIColor.whiteColor().CGColor
            keyView.layer.borderWidth = 2.5
            keyView.textColor = UIColor.whiteColor()
            keyView.text = GameManager.randomAlphaNumericString(1)
            keyView.textAlignment = NSTextAlignment.Center
            let fontEstimate:CGFloat = (UIDevice.currentDevice().userInterfaceIdiom == .Pad) ? 32 : 18
            let fontProportion:CGFloat = fontEstimate/min
            let fontSize = sideSize*fontProportion
            keyView.font = UIFont(name: "Helvetica-Bold", size: fontSize)
            keyView.frame.origin = CGPointMake(CGFloat(initialX), initialY)
            keyView.frame.size = CGSizeMake(sideSize, sideSize)
            keyView.layer.opacity = Float(GameManager.randRangeToChooseText(40, upper: 85))/100
            
            // Add to view array
            spawnedViews.append(keyView)
            print(self.spawnedViews.count)
            self.backgroundView.insertSubview(keyView, belowSubview: logoImageView)

            // Now add animation of falling
            let distance = screenHeight-initialY
            let speed = CGFloat(GameManager.randRangeToChooseText(80, upper: 130))
            let time = distance/speed
            CATransaction.begin()
            let fallAnimation: CABasicAnimation = CABasicAnimation(keyPath: "position.y")
            fallAnimation.duration = Double(time)
            fallAnimation.toValue = screenHeight+sideSize
            fallAnimation.fillMode = kCAFillModeForwards
            fallAnimation.removedOnCompletion = false
            CATransaction.setCompletionBlock {
                print("Cleaned Initial View")
                if !self.animationIsPaused {
                    if keyView != nil {
                        if keyView.tag != 1 { // tag 1 means it is already being removed
                            keyView.tag = 1
                            keyView.removeFromSuperview()
                            self.spawnedViews.removeAtIndex(self.spawnedViews.indexOf(keyView)!)
                            print(self.spawnedViews.count)
                        }
                    }
                }
                
            }
            keyView.layer.addAnimation(fallAnimation, forKey: "fallAnimation")
            CATransaction.commit()
            
        
        }
    }
    
    // Pause & Stop
    func returnedFromBackground() {
        print("returnedFromBackground")
        // Uncomment
        SoundManager.backgroundMusicPlayer.play()
        animateButtonsAndLogo()
        animateRain()
    }
    func willEnterBackground() {
        SoundManager.backgroundMusicPlayer.pause()
        stopRainAnimation()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("willAppear")
        // Uncomment
        SoundManager.backgroundMusicPlayer.play()
        animateButtonsAndLogo()
        animateRain()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(returnedFromBackground),
            name: UIApplicationDidBecomeActiveNotification,
            object: UIApplication.sharedApplication())
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(willEnterBackground),
            name: UIApplicationWillResignActiveNotification,
            object: UIApplication.sharedApplication())
        self.recordScoreLabel.text = GameManager.currentBestScore() == 0 ? "" : "Best Score: \(GameManager.currentBestScore())"

        
    }
    override func viewWillDisappear(animated: Bool) {
        print("Will Disappear")
        super.viewWillDisappear(animated)
        SoundManager.backgroundMusicPlayer.pause()
        stopRainAnimation()
        NSNotificationCenter.defaultCenter().removeObserver(self)

    }

    // Animations
    var initialLogoCenter:CGFloat = 0
    func animateRain() {
        
        if currentlyInShareMode {
            return
        }
        animationIsPaused = false

        if animationIsAlreadyActive {
            return
        } else {
            animationIsAlreadyActive = true
        }

        for view in self.spawnedViews {
            resumeLayer(view.layer)
            //            view.frame = (view.layer.presentationLayer() as! CALayer).frame
        }
        cleanupTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(cleanupViews), userInfo: nil, repeats: true)
        spawnViewLeft()
        spawnViewRight()
//        NSTimer.scheduledTimerWithTimeInterval(appearanceTime, invocation: NSInvoc, repeats: <#T##Bool#>)
    
    }
    var leftTimer:NSTimer!
    var rightTimer:NSTimer!
    var cleanupTimer:NSTimer!
    func spawnViewLeft() {
        let min:CGFloat = (UIDevice.currentDevice().userInterfaceIdiom == .Pad) ? 47 : 32
        let max:CGFloat = (UIDevice.currentDevice().userInterfaceIdiom == .Pad) ? 88 : 51
        let sideSize:CGFloat = CGFloat(GameManager.randRangeToChooseText(Int(min), upper: Int(max)))

        let upperLimit = screenWidth/2
        let initialX = GameManager.randRangeToChooseText(10, upper: Int(upperLimit)-Int(sideSize))

        let keyView = UILabel()
        
        keyView.layer.cornerRadius = 4
        keyView.layer.borderColor = UIColor.whiteColor().CGColor
        keyView.layer.borderWidth = 2.5
        keyView.textColor = UIColor.whiteColor()
        keyView.text = GameManager.randomAlphaNumericString(1)
        keyView.textAlignment = NSTextAlignment.Center
        let fontEstimate:CGFloat = (UIDevice.currentDevice().userInterfaceIdiom == .Pad) ? 32 : 18
        let fontProportion:CGFloat = fontEstimate/min
        let fontSize = sideSize*fontProportion
        keyView.font = UIFont(name: "Helvetica-Bold", size: fontSize)
        keyView.frame.origin = CGPointMake(CGFloat(initialX), -sideSize)
        keyView.frame.size = CGSizeMake(sideSize, sideSize)
        keyView.layer.opacity = 0

        spawnedViews.append(keyView)
        print(self.spawnedViews.count)
        self.backgroundView.insertSubview(keyView, belowSubview: logoImageView)
        animateSpawnedView(keyView)
        let nextSpawnTime = GameManager.randRangeToChooseText(1, upper: 2)
        leftTimer = NSTimer.scheduledTimerWithTimeInterval(Double(nextSpawnTime), target: self, selector: #selector(spawnViewLeft), userInfo: nil, repeats: false)
    }
    func spawnViewRight() {
        let min:CGFloat = (UIDevice.currentDevice().userInterfaceIdiom == .Pad) ? 47 : 32
        let max:CGFloat = (UIDevice.currentDevice().userInterfaceIdiom == .Pad) ? 88 : 51
        let sideSize:CGFloat = CGFloat(GameManager.randRangeToChooseText(Int(min), upper: Int(max)))
        
        let lowerLimit = screenWidth/2
        let upperLimit = screenWidth
        let initialX = GameManager.randRangeToChooseText(Int(lowerLimit), upper: Int(upperLimit)-10-Int(sideSize))
        
        let keyView = UILabel()
        
        keyView.layer.cornerRadius = 4
        keyView.layer.borderColor = UIColor.whiteColor().CGColor
        keyView.layer.borderWidth = 2.5
        keyView.textColor = UIColor.whiteColor()
        keyView.text = GameManager.randomAlphaNumericString(1)
        keyView.textAlignment = NSTextAlignment.Center
        
        let fontEstimate:CGFloat = (UIDevice.currentDevice().userInterfaceIdiom == .Pad) ? 32 : 16
        let fontProportion:CGFloat = fontEstimate/min
        let fontSize = sideSize*fontProportion
        keyView.font = UIFont(name: "Helvetica-Bold", size: fontSize)

        keyView.frame.origin = CGPointMake(CGFloat(initialX), -sideSize)
        keyView.frame.size = CGSizeMake(sideSize, sideSize)
        spawnedViews.append(keyView)
        print(self.spawnedViews.count)
        self.backgroundView.insertSubview(keyView, belowSubview: logoImageView)
        animateSpawnedView(keyView)
        
        let nextSpawnTime = GameManager.randRangeToChooseText(1, upper: 2)
        rightTimer = NSTimer.scheduledTimerWithTimeInterval(Double(nextSpawnTime), target: self, selector: #selector(spawnViewRight), userInfo: nil, repeats: false)
        
    }
    func animateSpawnedView(view:UIView!) {
        let distance = screenHeight+view.frame.height
        let speed = CGFloat(GameManager.randRangeToChooseText(80, upper: 130))
//        print("Random speed generated: \(speed)")
        
        let time = distance/speed
        
        
        // Animate transparency
        // 1 initial alpha
        view.layer.opacity = 0.0

        // 2 alpha changing
        let animation = CABasicAnimation(keyPath: "opacity")
        let logoDistance = logoImageView.frame.lowestY()
        let delay = logoDistance/speed
        let fadeTime = 50/speed
        
//        animation.fromValue = 0
        animation.toValue = CGFloat(GameManager.randRangeToChooseText(40, upper: 85))/100
        animation.duration = Double(fadeTime)
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        animation.beginTime = CACurrentMediaTime()+Double(delay)
        
        // Finally, add the animation to the layer
        view.layer.addAnimation(animation, forKey: "opacityAnimation")
        
        // Now add animation of falling
        CATransaction.begin()
        let fallAnimation: CABasicAnimation = CABasicAnimation(keyPath: "position.y")
        fallAnimation.duration = Double(time)
        fallAnimation.toValue = screenHeight+view.frame.height
        fallAnimation.fillMode = kCAFillModeForwards
        fallAnimation.removedOnCompletion = false
        CATransaction.setCompletionBlock {
            print("compl")
            if !self.animationIsPaused {
                if view != nil {
                    if view.tag != 1 { // tag 1 means it is already being removed
                        view.tag = 1
                        view.removeFromSuperview()
                        self.spawnedViews.removeAtIndex(self.spawnedViews.indexOf(view)!)
                        print(self.spawnedViews.count)
                    }
                }
            }

        }
        view.layer.addAnimation(fallAnimation, forKey: "fallAnimation")
        CATransaction.commit()
        
//        UIView.animateWithDuration(Double(time), delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
//            view.frame.origin.y = distance
//        }) { (finished:Bool) in
//            view.removeFromSuperview()
//            self.spawnedViews.removeAtIndex(self.spawnedViews.indexOf(view)!)
//            print(self.spawnedViews.count)
//        }
    }
    func stopRainAnimation() {
        
        if leftTimer != nil {
            leftTimer.invalidate()
            leftTimer = nil
        }
        if rightTimer != nil {
            rightTimer.invalidate()
            rightTimer = nil
        }
        
        if cleanupTimer != nil {
            cleanupTimer.invalidate()
            cleanupTimer = nil
        }
        for view in self.spawnedViews {
            pauseLayer(view.layer)
            
//            view.frame = (view.layer.presentationLayer() as! CALayer).frame
        }
        animationIsPaused = true
        animationIsAlreadyActive = false
        
    }
    func cleanupViews() {
        for view in spawnedViews {

            if (view.layer.presentationLayer() as! CALayer).position.y >= screenHeight+(view.frame.height/2) {
                print("Cleaned View")
                if view.tag != 1 { // tag 1 means it is already being removed
                    view.tag = 1
                    view.removeFromSuperview()
                    self.spawnedViews.removeAtIndex(self.spawnedViews.indexOf(view)!)
                    print(self.spawnedViews.count)
                }
            }
        }
    }
    func pauseLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    func resumeLayer(layer: CALayer) {
        
        let pausedTime: CFTimeInterval = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    func animateButtonsAndLogo() {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.toValue = 1.15
        scaleAnimation.duration = 0.4
        scaleAnimation.autoreverses = true
        scaleAnimation.repeatCount = HUGE
        self.playButton.layer.addAnimation(scaleAnimation, forKey: "scaleAnimation")
        
        let bounceAnimation = CABasicAnimation(keyPath: "position.x")
        bounceAnimation.fromValue = initialLogoCenter-5
        bounceAnimation.toValue = initialLogoCenter+5
        bounceAnimation.duration = 0.6
        bounceAnimation.autoreverses = true
        bounceAnimation.repeatCount = HUGE
        self.logoImageView.layer.addAnimation(bounceAnimation, forKey: "bounceAnimation")
        
        
        let rotationAngle:Double = 6
        let rotationDuration:Double = 0.4
        
        let rotateAnimation0 = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation0.fromValue = -rotationAngle.degreesToRadians
        rotateAnimation0.toValue = rotationAngle.degreesToRadians
        rotateAnimation0.duration = rotationDuration
        rotateAnimation0.autoreverses = true
        rotateAnimation0.repeatCount = HUGE
        self.soundOnOffButton.layer.addAnimation(rotateAnimation0, forKey: "rotateAnimation")
        
        let rotateAnimation1 = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation1.fromValue = -rotationAngle.degreesToRadians
        rotateAnimation1.toValue = rotationAngle.degreesToRadians
        rotateAnimation1.duration = rotationDuration
        rotateAnimation1.autoreverses = true
        rotateAnimation1.repeatCount = HUGE
        self.gameCenterButton.layer.addAnimation(rotateAnimation1, forKey: "rotateAnimation")
        
        let rotateAnimation2 = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation2.fromValue = -rotationAngle.degreesToRadians
        rotateAnimation2.toValue = rotationAngle.degreesToRadians
        rotateAnimation2.duration = rotationDuration
        rotateAnimation2.autoreverses = true
        rotateAnimation2.repeatCount = HUGE
        self.languageButton.layer.addAnimation(rotateAnimation2, forKey: "rotateAnimation")
        
        
        let rotateAnimation3 = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation3.fromValue = -rotationAngle.degreesToRadians
        rotateAnimation3.toValue = rotationAngle.degreesToRadians
        rotateAnimation3.duration = rotationDuration
        rotateAnimation3.autoreverses = true
        rotateAnimation3.repeatCount = HUGE
        self.shareButton.layer.addAnimation(rotateAnimation3, forKey: "rotateAnimation")
        
    }
    
    // Actions & Buttons
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    func didPressReturnToHome() {
        self.dismissViewControllerAnimated(true) {
            
        }
    }
    func soundOnOff(sender:UIButton) {
        sender.selected = !sender.selected
        soundOnOffButton.selected = sender.selected
        soundOnOffButton.selected ? GameManager.turnSoundOn() : GameManager.turnSoundOff()
        if soundOnOffButton.selected {
            SoundManager.clickSoundPlayer.play()
        }
        let volume:Float = soundOnOffButton.selected ? 1 : 0
        SoundManager.backgroundMusicPlayer.volume = volume
        
    }
    func showLeaderboard() {
        let gcVC: GKGameCenterViewController = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = GKGameCenterViewControllerState.Leaderboards
        gcVC.leaderboardIdentifier = "LeaderboardID"
        self.presentViewController(gcVC, animated: true, completion: nil)
    }
    func openGameCenter() {
        showLeaderboard()
        print("List")
    }
    func play() {
        let VC = self.storyboard!.instantiateViewControllerWithIdentifier("GameViewController") as! GameViewController
        VC.delegate = self
        self.presentViewController(VC, animated: true) {
            
            
            
            VC.gameendview.soundButton.addTarget(self, action: #selector(self.soundOnOff(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            VC.gameendview.soundButton.selected = GameManager.isSoundOn()
            
        }
    }
    
    var currentlyInShareMode = false
    func share() {
        
//        let vc = self.view?.window?.rootViewController
        let image = GameManager.generateShareRecordImage()
        
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.popoverPresentationController?.sourceRect = CGRectMake(screenWidth/2, screenHeight/2, 1, 1)
        stopRainAnimation()
        currentlyInShareMode = true
        activityVC.completionWithItemsHandler = {
             (activityType: String?, completed: Bool,objects:[AnyObject]?, error:NSError?) -> Void in
            self.currentlyInShareMode = false
            self.animateRain()
            print("end")
            
            
        }
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    

    

}
