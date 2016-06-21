//
//  SwitchLanguageView.swift
//  TextSpeed
//
//  Created by Grisha on 20/06/2016.
//  Copyright © 2016 Grisha. All rights reserved.
//

import UIKit
protocol SwitchLanguageButtonDelegate {
    func changedLanguage(language:Language)
}
class SwitchLanguageView: UIView {
    var delegate:SwitchLanguageButtonDelegate!
    let englishLabel = ExpandButton()
    let russianLabel = ExpandButton()
    let italianLabel = ExpandButton()
    let germanLabel = ExpandButton()
    let frenchLabel = ExpandButton()
    let portugueseLabel = ExpandButton()
    let spanishLabel = ExpandButton()
    var buttons:[ExpandButton] = []
    var currentlySelectedLanguage:Language!
    func initializeLabel() {
        currentlySelectedLanguage = AppDelegate.chosenLanguage
//        self.backgroundColor = ColorFromCode.colorWithHexString("3F0C51").colorWithAlphaComponent(0.85)
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.9)
        self.layer.borderColor = UIColor.whiteColor().CGColor
        buttons.append(englishLabel)
        buttons.append(russianLabel)
        buttons.append(italianLabel)
        buttons.append(germanLabel)
        buttons.append(frenchLabel)
        buttons.append(portugueseLabel)
        buttons.append(spanishLabel)

        // Big Buttons
        self.addSubview(englishLabel)
        self.addSubview(italianLabel)
        self.addSubview(russianLabel)
        self.addSubview(frenchLabel)
        self.addSubview(germanLabel)
        self.addSubview(portugueseLabel)
        self.addSubview(spanishLabel)
        
        self.englishLabel.translatesAutoresizingMaskIntoConstraints = false
        self.italianLabel.translatesAutoresizingMaskIntoConstraints = false
        self.russianLabel.translatesAutoresizingMaskIntoConstraints = false
        self.frenchLabel.translatesAutoresizingMaskIntoConstraints = false
        self.germanLabel.translatesAutoresizingMaskIntoConstraints = false
        self.portugueseLabel.translatesAutoresizingMaskIntoConstraints = false
        self.spanishLabel.translatesAutoresizingMaskIntoConstraints = false

        let views = [
            "englishLabel" : englishLabel,
            "italianLabel" : italianLabel,
            "russianLabel" : russianLabel,
            "frenchLabel" : frenchLabel,
            "germanLabel" : germanLabel,
            "portugueseLabel" : portugueseLabel,
            "spanishLabel" : spanishLabel
        ]
        var h = GameManager.screenHeight()
        if GameManager.screenWidth() > h {
            h = GameManager.screenWidth()
        }
        let scale = h/568 // scale = height
        let viewProportion:CGFloat = 200/262 //  = width / height
        let viewHeight = 262*scale
        let viewWidth = viewProportion * viewHeight
        self.frame.size = CGSizeMake(viewWidth, viewHeight)
        self.layer.borderWidth = 3*scale
        let yOffset = 25*scale
        let buttonSide:CGFloat = 18*scale
        let numberOfButtons:CGFloat = 7
        self.layer.cornerRadius = yOffset

        let ySpacing = ((viewHeight-yOffset*2)-(buttonSide*numberOfButtons))/(numberOfButtons-1)
        
        let metrics = [
            "bSd" : buttonSide,
            "ySp": ySpacing,
            "yOf" : yOffset
        ]
        
        let vflString = "V:|-yOf@999-[englishLabel(bSd@999)]-ySp@999-[italianLabel(bSd@999)]-ySp@999-[russianLabel(bSd@999)]-ySp@999-[frenchLabel(bSd@999)]-ySp@999-[germanLabel(bSd@999)]-ySp@999-[portugueseLabel(bSd@999)]-ySp@999-[spanishLabel(bSd@999)]"
        let svConstraints0 = NSLayoutConstraint.constraintsWithVisualFormat(vflString, options: [NSLayoutFormatOptions.AlignAllCenterX], metrics: metrics, views: views)
        
        
        let centerXConstraint = NSLayoutConstraint(item: englishLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        self.addConstraint(centerXConstraint)
        self.addConstraints(svConstraints0)
        customizeViews()
        setSelectedLanguage(AppDelegate.chosenLanguage)
    }
    
    
    func customizeViews() {
        var h = GameManager.screenHeight()
        if GameManager.screenWidth() > h {
            h = GameManager.screenWidth()
        }
        let scale = h/568 // scale = height
        let font = UIFont(name: "Resamitz", size: 16*scale)!
        
        self.englishLabel.setTitle("English", forState: UIControlState.Normal)
        self.englishLabel.titleLabel!.font = font
        self.englishLabel.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.englishLabel.addTarget(self, action: #selector(selectLanguage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.englishLabel.tag = 0
        
        self.russianLabel.setTitle("Russian", forState: UIControlState.Normal)
        self.russianLabel.titleLabel!.font = font
        self.russianLabel.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.russianLabel.addTarget(self, action: #selector(selectLanguage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.russianLabel.tag = 1

        self.spanishLabel.setTitle("Spanish", forState: UIControlState.Normal)
        self.spanishLabel.titleLabel!.font = font
        self.spanishLabel.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.spanishLabel.addTarget(self, action: #selector(selectLanguage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.spanishLabel.tag = 2

        self.portugueseLabel.setTitle("Portuguese", forState: UIControlState.Normal)
        self.portugueseLabel.titleLabel!.font = font
        self.portugueseLabel.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.portugueseLabel.addTarget(self, action: #selector(selectLanguage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.portugueseLabel.tag = 3

        self.italianLabel.setTitle("Italian", forState: UIControlState.Normal)
        self.italianLabel.titleLabel!.font = font
        self.italianLabel.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.italianLabel.addTarget(self, action: #selector(selectLanguage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.italianLabel.tag = 4

        self.germanLabel.setTitle("German", forState: UIControlState.Normal)
        self.germanLabel.titleLabel!.font = font
        self.germanLabel.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.germanLabel.addTarget(self, action: #selector(selectLanguage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.germanLabel.tag = 5

        self.frenchLabel.setTitle("French", forState: UIControlState.Normal)
        self.frenchLabel.titleLabel!.font = font
        self.frenchLabel.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.frenchLabel.addTarget(self, action: #selector(selectLanguage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.frenchLabel.tag = 6

    }
    
    func setSelectedLanguage(language:Language) {
        self.currentlySelectedLanguage = language
        var ttag = 0
        switch language {
        case .English: ttag = 0
        case .Russian: ttag = 1
        case .Spanish: ttag = 2
        case .Portuguese: ttag = 3
        case .Italian: ttag = 4
        case .German: ttag = 5
        case .French: ttag = 6
        default: ttag = 0
        }
        for button in self.buttons {
            if button.tag == ttag {
                button.setTitleColor(ColorFromCode.colorWithHexString("FF7D0C"), forState: UIControlState.Normal)
            } else {
                button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                
            }
        }
    }
    
    
    func selectLanguage(sender:UIButton) {
        switch sender.tag {
        case 0: delegate!.changedLanguage(Language.English)
        case 1: delegate!.changedLanguage(Language.Russian)
        case 2: delegate!.changedLanguage(Language.Spanish)
        case 3: delegate!.changedLanguage(Language.Portuguese)
        case 4: delegate!.changedLanguage(Language.Italian)
        case 5: delegate!.changedLanguage(Language.German)
        case 6: delegate!.changedLanguage(Language.French)
        default: delegate!.changedLanguage(Language.English)
        }
    }
 
}
