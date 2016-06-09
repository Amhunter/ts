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
    var scoreLeftLabel = UILabel()
    var scoreRightLabel = UILabel()
    var startAgainButton = ExpandButton()
    
    
    var buttonsSuperview = UIView()
    var homeButton = ExpandButton()
    var gamecenterButton = ExpandButton()
    var soundButton = ExpandButton()

    func initializeView() {
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.9)
        self.userInteractionEnabled = false
        self.alpha = 0
        
        self.addSubview(endLabel)
        self.addSubview(labelsSuperview)

        self.addSubview(startAgainButton)
        self.addSubview(buttonsSuperview)

        self.endLabel.translatesAutoresizingMaskIntoConstraints = false
        self.labelsSuperview.translatesAutoresizingMaskIntoConstraints = false

        self.startAgainButton.translatesAutoresizingMaskIntoConstraints = false
        self.buttonsSuperview.translatesAutoresizingMaskIntoConstraints = false


        let views = [
            "endLabel" : endLabel,
            "labelsSuperview": labelsSuperview,
            "buttonsSuperview" : buttonsSuperview,
            "startAgainButton" : startAgainButton
        ]
        
        let scale:CGFloat = screenHeight/667
        let bottomOffset:CGFloat = 61*scale
        let replaySide:CGFloat = 94*scale
        let textToButtonSpacing:CGFloat = 88*scale
        let sideTextOffset:CGFloat = 70*scale
        let buttonTopOffset:CGFloat = 135*scale


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

        let hConstraint2 = NSLayoutConstraint(item: startAgainButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let hConstraint3 = NSLayoutConstraint(item: buttonsSuperview, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let circleConstraint4 = NSLayoutConstraint(item: startAgainButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: startAgainButton, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)

        
        let vConstraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-100@999-[endLabel][labelsSuperview(>=buttonTopOffset@999)][startAgainButton(replaySide@999)]-71@700-[buttonsSuperview]-botOffset@999-|", options: [], metrics: metrics, views: views)
        
        
        self.addConstraints(hConstraints0)
        self.addConstraint(hConstraint1)
        self.addConstraint(hConstraint2)
        self.addConstraint(hConstraint3)
        self.addConstraint(circleConstraint4)

        self.addConstraints(vConstraints0)
        
        
        // Labels Superview
        
        labelsSuperview.addSubview(scoreLeftLabel)
        labelsSuperview.addSubview(scoreRightLabel)
        
        self.scoreLeftLabel.translatesAutoresizingMaskIntoConstraints = false
        self.scoreRightLabel.translatesAutoresizingMaskIntoConstraints = false
        let lviews = [
            "scoreLeftLabel" : scoreLeftLabel,
            "scoreRightLabel" : scoreRightLabel,
        ]
        
        
        let lhConstraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[scoreLeftLabel]-50-[scoreRightLabel]|", options: [NSLayoutFormatOptions.AlignAllCenterY, NSLayoutFormatOptions.AlignAllTop, NSLayoutFormatOptions.AlignAllBottom], metrics: metrics, views: lviews)
        let lvConstraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[scoreLeftLabel]|", options: [], metrics: metrics, views: lviews)

        labelsSuperview.addConstraints(lhConstraints0)
        labelsSuperview.addConstraints(lvConstraints0)

        
        // Buttons Superview
        buttonsSuperview.addSubview(homeButton)
        buttonsSuperview.addSubview(gamecenterButton)
        buttonsSuperview.addSubview(soundButton)

        self.homeButton.translatesAutoresizingMaskIntoConstraints = false
        self.gamecenterButton.translatesAutoresizingMaskIntoConstraints = false
        self.soundButton.translatesAutoresizingMaskIntoConstraints = false
        
        let sbviews = [
            "homeButton" : homeButton,
            "gamecenterButton" : gamecenterButton,
            "soundButton" : soundButton
        ]
        
        let sbmetrics = [
            "btnSize": 62*scale,
            //            "tw" : topOffset
        ]
        
        let shConstraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[homeButton(==btnSize@999)]-41@999-[gamecenterButton(==btnSize@999)]-41@999-[soundButton(==btnSize@999)]|", options: [NSLayoutFormatOptions.AlignAllCenterY,NSLayoutFormatOptions.AlignAllTop,NSLayoutFormatOptions.AlignAllBottom], metrics: sbmetrics, views: sbviews)

        let shConstraint1 = NSLayoutConstraint(item: homeButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: homeButton, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        let shConstraint2 = NSLayoutConstraint(item: gamecenterButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: gamecenterButton, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        let shConstraint3 = NSLayoutConstraint(item: soundButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: soundButton, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        let svConstraints4 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[homeButton]|", options: [], metrics: metrics, views: sbviews)
        
        buttonsSuperview.addConstraints(shConstraints0)
        buttonsSuperview.addConstraint(shConstraint1)
        buttonsSuperview.addConstraint(shConstraint2)
        buttonsSuperview.addConstraint(shConstraint3)
        buttonsSuperview.addConstraints(svConstraints4)
        
        
        
        
        
        
        
        self.endLabel.text = "END"
        self.endLabel.font = UIFont(name: "Times New Roman", size: 72*scale)
        self.endLabel.textColor = UIColor.whiteColor()
        self.endLabel.textAlignment = NSTextAlignment.Center
        
        
        self.scoreLeftLabel.text = "CURRENT SCORE\nBest score\nSpeed"
        self.scoreLeftLabel.numberOfLines = 0
        self.scoreLeftLabel.font = UIFont(name: "Times New Roman", size: 24*scale)
        self.scoreLeftLabel.textColor = UIColor.whiteColor()
        self.scoreLeftLabel.textAlignment = NSTextAlignment.Left
        
        self.scoreRightLabel.numberOfLines = 0
        self.scoreRightLabel.font = UIFont(name: "Times New Roman", size: 24*scale)
        self.scoreRightLabel.textColor = UIColor.whiteColor()
        self.scoreRightLabel.textAlignment = NSTextAlignment.Right
        
        
        
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        self.startAgainButton.setImage(UIImage(named: "replay2x"), forState: UIControlState.Normal)
        self.startAgainButton.backgroundColor = UIColor.whiteColor()
        self.startAgainButton.layer.cornerRadius = self.startAgainButton.frame.width/2
        
        self.soundButton.setImage(UIImage(named: "soundon2x"), forState: UIControlState.Selected)
        self.soundButton.setImage(UIImage(named: "soundoff2x"), forState: UIControlState.Normal)
        self.soundButton.backgroundColor = UIColor.whiteColor()
        self.soundButton.layer.cornerRadius = self.soundButton.frame.width/2
        
        self.homeButton.setImage(UIImage(named: "home2x"), forState: UIControlState.Normal)
        self.homeButton.backgroundColor = UIColor.whiteColor()
        self.homeButton.layer.cornerRadius = self.homeButton.frame.width/2
        
        self.gamecenterButton.setImage(UIImage(named: "list2x"), forState: UIControlState.Normal)
        self.gamecenterButton.backgroundColor = UIColor.whiteColor()
        self.gamecenterButton.layer.cornerRadius = self.gamecenterButton.frame.width/2
    }
    
    
    func showResult(currentScore:Int,bestScore:Int,speed:Int) {
        let currentScoreString = "\(currentScore)".capitalizedString
        self.scoreRightLabel.text = "\(currentScoreString)\n\(bestScore)\n\(speed)spm"

    }

}
