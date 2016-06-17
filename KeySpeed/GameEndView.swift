//
//  GameEndView.swift
//  KeySpeed
//
//  Created by Grisha on 29/05/2016.
//  Copyright © 2016 Grisha. All rights reserved.
//

import UIKit

class GameEndView: UIView {
    
    let screenHeight = UIScreen.mainScreen().bounds.height
    let screenWidth = UIScreen.mainScreen().bounds.width

    var endLabel = UILabel()
    var labelsSuperview = UIView()
    let scoreLabel =  SACountingLabel()
    var bestScoreLabel = UILabel()
    var speedLabel = UILabel()
    var replayButton = ExpandButton()
    
    
    var buttonsSuperview = UIView()
    var homeButton = ExpandButton()
    var gameCenterButton = ExpandButton()
    var soundButton = ExpandButton()
    var shareButton = ExpandButton()
    
    var initialBestScorePosition:CGFloat = 0
    func initializeView() {
        self.backgroundColor = ColorFromCode.colorWithHexString("#2B001D").colorWithAlphaComponent(0.9)
        self.userInteractionEnabled = false
        self.alpha = 0
        
        self.addSubview(endLabel)
        self.addSubview(replayButton)
        self.addSubview(labelsSuperview)
        self.addSubview(buttonsSuperview)

        self.endLabel.translatesAutoresizingMaskIntoConstraints = false
        self.scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        self.bestScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        self.speedLabel.translatesAutoresizingMaskIntoConstraints = false
        self.labelsSuperview.translatesAutoresizingMaskIntoConstraints = false

        self.replayButton.translatesAutoresizingMaskIntoConstraints = false
        self.buttonsSuperview.translatesAutoresizingMaskIntoConstraints = false


        let views = [
            "endLabel" : endLabel,
//            "scoreLabel": scoreLabel,
//            "bestScoreLabel": bestScoreLabel,
//            "speedLabel": speedLabel,
            "labelsSuperview": labelsSuperview,
            "buttonsSuperview" : buttonsSuperview,
            "replayButton" : replayButton
        ]
        
        let scale:CGFloat = screenHeight/667
        let bottomOffset:CGFloat = 61*scale
        let replaySide:CGFloat = 94*scale
        let textToButtonSpacing:CGFloat = 88*scale
        let sideTextOffset:CGFloat = 70*scale
        let buttonTopOffset:CGFloat = 60*scale


        let metrics = [
            "leftOffset": 11,
            "replaySide": replaySide,
            "botOffset": bottomOffset,
            "sideTextOffset": sideTextOffset,
            "buttonTopOffset": buttonTopOffset,
            "upperTextSpacing": textToButtonSpacing,
            "lowerTextSpacing": textToButtonSpacing/1.5
        ]
        let hConstraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[endLabel]-20@999-|", options: [], metrics: metrics, views: views)
        let hConstraint1 = NSLayoutConstraint(item: labelsSuperview, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
//        let hConstraint2 = NSLayoutConstraint(item: bestScoreLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
//        let hConstraint3 = NSLayoutConstraint(item: speedLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let hConstraint4 = NSLayoutConstraint(item: replayButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let hConstraint5 = NSLayoutConstraint(item: buttonsSuperview, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let circleConstraint4 = NSLayoutConstraint(item: replayButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: replayButton, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)

        let vConstraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-100@999-[endLabel]-[labelsSuperview]-buttonTopOffset@999-[replayButton(replaySide@999)]-71@700-[buttonsSuperview]-botOffset@999-|", options: [], metrics: metrics, views: views)
//        let vConstraint1 = NSLayoutConstraint(item: buttonsSuperview, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)

        
        self.addConstraints(hConstraints0)
        self.addConstraints([hConstraint1, hConstraint4, hConstraint5, circleConstraint4])
        self.addConstraints(vConstraints0)
        
        
        // Labels Superview
        
        labelsSuperview.addSubview(scoreLabel)
        labelsSuperview.addSubview(bestScoreLabel)
        labelsSuperview.addSubview(speedLabel)
        
        self.scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        self.bestScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        let lviews = [
            "scoreLabel" : scoreLabel,
            "bestScoreLabel" : bestScoreLabel,
            "speedLabel" : speedLabel
        ]
        
        let lmetrics = [
            "vsp" : 5
        ]
        
        let lhConstraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[scoreLabel]|", options: [], metrics: metrics, views: lviews)
        let lvConstraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[scoreLabel]-vsp@999-[bestScoreLabel]-vsp@999-[speedLabel]|", options: [.AlignAllLeft, .AlignAllRight], metrics: lmetrics, views: lviews)

        labelsSuperview.addConstraints(lhConstraints0)
        labelsSuperview.addConstraints(lvConstraints0)

        
        // Buttons Superview
        buttonsSuperview.addSubview(homeButton)
        buttonsSuperview.addSubview(gameCenterButton)
        buttonsSuperview.addSubview(soundButton)
        buttonsSuperview.addSubview(shareButton)

        self.homeButton.translatesAutoresizingMaskIntoConstraints = false
        self.gameCenterButton.translatesAutoresizingMaskIntoConstraints = false
        self.soundButton.translatesAutoresizingMaskIntoConstraints = false
        self.shareButton.translatesAutoresizingMaskIntoConstraints = false

        let sbviews = [
            "homeButton" : homeButton,
            "gameCenterButton" : gameCenterButton,
            "soundButton" : soundButton,
            "shareButton" : shareButton
        ]
        
        let sbmetrics = [
            "btnSize": 63*scale,
            "btnSpc": 30*scale
            //            "tw" : topOffset
        ]
        
        let shConstraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[homeButton(==btnSize@999)]-btnSpc@999-[shareButton(==btnSize@999)]-btnSpc@999-[gameCenterButton(==btnSize@999)]-btnSpc@999-[soundButton(==btnSize@999)]|", options: [NSLayoutFormatOptions.AlignAllCenterY,NSLayoutFormatOptions.AlignAllTop,NSLayoutFormatOptions.AlignAllBottom], metrics: sbmetrics, views: sbviews)

        let shConstraint1 = NSLayoutConstraint(item: homeButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: homeButton, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        let shConstraint2 = NSLayoutConstraint(item: gameCenterButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: gameCenterButton, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        let shConstraint3 = NSLayoutConstraint(item: soundButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: soundButton, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        let svConstraints4 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[homeButton]|", options: [], metrics: metrics, views: sbviews)
        
        buttonsSuperview.addConstraints(shConstraints0)
        buttonsSuperview.addConstraint(shConstraint1)
        buttonsSuperview.addConstraint(shConstraint2)
        buttonsSuperview.addConstraint(shConstraint3)
        buttonsSuperview.addConstraints(svConstraints4)
        
        
        
        
        
        
        
        self.endLabel.text = "END"
        self.endLabel.font = UIFont(name: "Resamitz", size: 72*scale)
        self.endLabel.textColor = UIColor.whiteColor()
        self.endLabel.textAlignment = NSTextAlignment.Center
        
//        self.scoreLabel.text = "138"
        self.scoreLabel.font = UIFont(name: "Resamitz", size: 48*scale)
        self.scoreLabel.textColor = UIColor.whiteColor()
        self.scoreLabel.textAlignment = NSTextAlignment.Center
        self.scoreLabel.countingType = .Int
        
//        self.scoreLeftLabel.text = "Best Score:\nSpeed:"
//        self.scoreLeftLabel.numberOfLines = 0
//        self.scoreLeftLabel.font = UIFont(name: "Resamitz", size: 20*scale)
//        self.scoreLeftLabel.textColor = ColorFromCode.colorWithHexString("#FF7D0C")
//        self.scoreLeftLabel.textAlignment = NSTextAlignment.Left
//        
//        self.scoreRightLabel.numberOfLines = 0
//        self.scoreRightLabel.font = UIFont(name: "Resamitz", size: 20*scale)
//        self.scoreRightLabel.textColor = ColorFromCode.colorWithHexString("#FF7D0C")
//        self.scoreRightLabel.textAlignment = NSTextAlignment.Right
        
        self.bestScoreLabel.font = UIFont(name: "Resamitz", size: 20*scale)
        self.bestScoreLabel.textColor = ColorFromCode.colorWithHexString("#FF7D0C")
        self.bestScoreLabel.textAlignment = NSTextAlignment.Center
        
        self.speedLabel.font = UIFont(name: "Resamitz", size: 20*scale)
        self.speedLabel.textColor = UIColor.whiteColor()
        self.speedLabel.textAlignment = NSTextAlignment.Center
        
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        self.replayButton.setImage(UIImage(named: "bigReplay"), forState: UIControlState.Normal)
        self.replayButton.backgroundColor = ColorFromCode.colorWithHexString("#55106E")
        self.replayButton.layer.cornerRadius = self.replayButton.frame.width/2
        
        self.homeButton.setImage(UIImage(named: "smallHome"), forState: UIControlState.Normal)
        self.homeButton.backgroundColor = ColorFromCode.colorWithHexString("#55106E")
        self.homeButton.layer.cornerRadius = self.homeButton.frame.width/2
        
        self.gameCenterButton.setImage(UIImage(named: "homeGamecenter"), forState: UIControlState.Normal)
        self.gameCenterButton.layer.cornerRadius = gameCenterButton.frame.width/2
        self.gameCenterButton.backgroundColor = ColorFromCode.colorWithHexString("#55106E")
        
        self.shareButton.setImage(UIImage(named: "homeShare2x"), forState: UIControlState.Normal)
        self.shareButton.backgroundColor = ColorFromCode.colorWithHexString("#55106E")
        self.shareButton.layer.cornerRadius = self.shareButton.frame.width/2
        
        self.soundButton.setImage(UIImage(named: "homeSoundOn"), forState: UIControlState.Selected)
        self.soundButton.setImage(UIImage(named: "homeSoundOff"), forState: UIControlState.Normal)
        self.soundButton.backgroundColor = ColorFromCode.colorWithHexString("#55106E")
        self.soundButton.layer.cornerRadius = self.soundButton.frame.width/2
        self.soundButton.disableSound = true

    }
    
    func showResult(currentScore:Int,bestScore:Int,speed:Int, newRecord:Bool) {
        
        
        let countingDuration:Double = 2
        self.scoreLabel.countFrom(0, to: Float(currentScore), withDuration: countingDuration, andAnimationType: SACountingLabel.AnimationType.EaseInOut, andCountingType: SACountingLabel.CountingType.Int)
        
        self.bestScoreLabel.text = newRecord ? "New Record!" : "Best Score: \(bestScore)"
        self.speedLabel.text = "Speed: \(speed) spm"
        
        // Fade Animation
        self.bestScoreLabel.alpha = 0
        self.speedLabel.alpha = 0
        UIView.animateWithDuration(0.25, delay: countingDuration, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.bestScoreLabel.alpha = 1
            self.speedLabel.alpha = 1
        }) { (finished:Bool) in
            if newRecord {
                SoundManager.newBestScorePlayer.tryToPlay()
                let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
                scaleAnimation.toValue = 1.10
                scaleAnimation.duration = 0.4
                scaleAnimation.autoreverses = true
                scaleAnimation.repeatCount = HUGE
                self.bestScoreLabel.layer.addAnimation(scaleAnimation, forKey: "scaleAnimation")
            } else {
                self.bestScoreLabel.layer.removeAllAnimations()
            }

        }
        
        

//        self.scoreRightLabel.text = "\(bestScore)\n\(speed)spm"

    }
    
    func animateButtons(animate:Bool) {
        if animate {
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.toValue = 1.15
            scaleAnimation.duration = 0.4
            scaleAnimation.autoreverses = true
            scaleAnimation.repeatCount = HUGE
            self.replayButton.layer.addAnimation(scaleAnimation, forKey: "scaleAnimation")
            
            let rotationAngle:Double = 6
            let rotationDuration:Double = 0.4
            
            let rotateAnimation0 = CABasicAnimation(keyPath: "transform.rotation.z")
            rotateAnimation0.fromValue = -rotationAngle.degreesToRadians
            rotateAnimation0.toValue = rotationAngle.degreesToRadians
            rotateAnimation0.duration = rotationDuration
            rotateAnimation0.autoreverses = true
            rotateAnimation0.repeatCount = HUGE
            self.soundButton.layer.addAnimation(rotateAnimation0, forKey: "rotateAnimation")
            
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
            self.homeButton.layer.addAnimation(rotateAnimation2, forKey: "rotateAnimation")
            
            
            let rotateAnimation3 = CABasicAnimation(keyPath: "transform.rotation.z")
            rotateAnimation3.fromValue = -rotationAngle.degreesToRadians
            rotateAnimation3.toValue = rotationAngle.degreesToRadians
            rotateAnimation3.duration = rotationDuration
            rotateAnimation3.autoreverses = true
            rotateAnimation3.repeatCount = HUGE
            self.shareButton.layer.addAnimation(rotateAnimation3, forKey: "rotateAnimation")
        } else {
            self.replayButton.layer.removeAllAnimations()
            self.homeButton.layer.removeAllAnimations()
            self.soundButton.layer.removeAllAnimations()
            self.gameCenterButton.layer.removeAllAnimations()
            self.shareButton.layer.removeAllAnimations()
            self.bestScoreLabel.layer.removeAllAnimations()

        }
    }
}
