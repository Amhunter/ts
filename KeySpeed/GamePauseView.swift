//
//  GamePauseView.swift
//  KeySpeed
//
//  Created by Grisha on 30/05/2016.
//  Copyright © 2016 Grisha. All rights reserved.
//

import UIKit

class GamePauseView: UIView {
    
    let screenHeight = UIScreen.mainScreen().bounds.height
    let screenWidth = UIScreen.mainScreen().bounds.width
    
    var pauseLabel = UILabel()
    
    
    var buttonsSuperview = UIView()
    var homeButton = ExpandButton()
    var resumeButton = ExpandButton()
    var replayButton = ExpandButton()
    func initializeView() {
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.9)
        self.userInteractionEnabled = false
        self.alpha = 0
        
        self.addSubview(pauseLabel)
        self.addSubview(buttonsSuperview)
        
        self.pauseLabel.translatesAutoresizingMaskIntoConstraints = false
        self.buttonsSuperview.translatesAutoresizingMaskIntoConstraints = false
        
        
        let views = [
            "pauseLabel" : pauseLabel,
            "buttonsSuperview" : buttonsSuperview
        ]
        
        let scale:CGFloat = screenHeight/667
        let bottomOffset:CGFloat = 61*scale
        let resumeSide:CGFloat = 94*scale
        let textToButtonSpacing:CGFloat = 88*scale
        let sideTextOffset:CGFloat = 70*scale
        let buttonTopOffset:CGFloat = 135*scale

        
        let metrics = [
            "leftOffset": 11,
            "botOffset": bottomOffset,
            "sideTextOffset": sideTextOffset,
            "buttonTopOffset" : buttonTopOffset,
            "upperTextSpacing": textToButtonSpacing,
            "lowerTextSpacing": textToButtonSpacing/1.5
        ]
        let hConstraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[pauseLabel]-20@999-|", options: [], metrics: metrics, views: views)
        let hConstraint1 = NSLayoutConstraint(item: buttonsSuperview, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        
        
        let vConstraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-100@999-[pauseLabel]-buttonTopOffset@999-[buttonsSuperview]->=botOffset@999-|", options: [], metrics: metrics, views: views)
        
        
        self.addConstraints(hConstraints0)
        self.addConstraint(hConstraint1)
        self.addConstraints(vConstraints0)
        
        
        buttonsSuperview.addSubview(homeButton)
        buttonsSuperview.addSubview(resumeButton)
        buttonsSuperview.addSubview(replayButton)

        self.homeButton.translatesAutoresizingMaskIntoConstraints = false
        self.resumeButton.translatesAutoresizingMaskIntoConstraints = false
        self.replayButton.translatesAutoresizingMaskIntoConstraints = false

        let sbviews = [
            "homeButton" : homeButton,
            "resumeButton" : resumeButton,
            "replayButton" : replayButton
        ]
        
        let sbmetrics = [
            "resumeSide": resumeSide,
            //            "tw" : topOffset
        ]
        
        let shConstraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[homeButton(==resumeSide@999)]-41@999-[resumeButton(==resumeSide@999)]|", options: [NSLayoutFormatOptions.AlignAllCenterY,NSLayoutFormatOptions.AlignAllTop,NSLayoutFormatOptions.AlignAllBottom], metrics: sbmetrics, views: sbviews)
        let shConstraint1 = NSLayoutConstraint(item: replayButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: buttonsSuperview, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        
        
        let squareConstraint0 = NSLayoutConstraint(item: replayButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: replayButton, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        let squareConstraint1 = NSLayoutConstraint(item: homeButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: homeButton, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        let squareConstraint2 = NSLayoutConstraint(item: resumeButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: resumeButton, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        let svConstraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[replayButton(==resumeSide@999)]-41@999-[homeButton]|", options: [], metrics: sbmetrics, views: sbviews)
        
        buttonsSuperview.addConstraints(shConstraints0)
        buttonsSuperview.addConstraint(shConstraint1)
        buttonsSuperview.addConstraint(squareConstraint0)
        buttonsSuperview.addConstraint(squareConstraint1)
        buttonsSuperview.addConstraint(squareConstraint2)
        
        buttonsSuperview.addConstraints(svConstraints0)
        
        
        
        self.pauseLabel.text = "PAUSE"
        self.pauseLabel.font = UIFont(name: "Times New Roman", size: 72*scale)
        self.pauseLabel.textColor = UIColor.whiteColor()
        self.pauseLabel.textAlignment = NSTextAlignment.Center
        
        
        
        
        
        
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        self.replayButton.setImage(UIImage(named: "replay2x"), forState: UIControlState.Normal)
        self.replayButton.backgroundColor = UIColor.whiteColor()
        self.replayButton.layer.cornerRadius = self.replayButton.frame.width/2
        
        self.homeButton.setImage(UIImage(named: "homeBig2x"), forState: UIControlState.Normal)
        self.homeButton.backgroundColor = UIColor.whiteColor()
        self.homeButton.layer.cornerRadius = self.homeButton.frame.width/2
        
        self.resumeButton.setImage(UIImage(named: "resume2x"), forState: UIControlState.Normal)
        self.resumeButton.backgroundColor = UIColor.whiteColor()
        self.resumeButton.layer.cornerRadius = self.resumeButton.frame.width/2
    }
    
    
    func showResult(symbolsPerMinute:Int) {
        
    }
    
}
