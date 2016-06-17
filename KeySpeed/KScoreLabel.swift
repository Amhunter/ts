//
//  KScoreLabel.swift
//  KeySpeed
//
//  Created by Grisha on 07/06/2016.
//  Copyright © 2016 Grisha. All rights reserved.
//

import UIKit

extension UILabel {
    
    /// The receiver’s font size, including any adjustment made to fit to width. (read-only)
    ///
    /// If `adjustsFontSizeToFitWidth` is not `true`, this is just an alias for
    /// `.font.pointSize`. If it is `true`, it returns the adjusted font size.
    ///
    /// Derived from: [http://stackoverflow.com/a/28285447/5191100](http://stackoverflow.com/a/28285447/5191100)
    var fontSize: CGFloat {
        get {
            if self.adjustsFontSizeToFitWidth == false || self.minimumScaleFactor >= 1.0 {
                // font adjustment is disabled
                return self.font.pointSize
            }
            let unadjustedSize: CGSize = self.text!.sizeWithAttributes([NSFontAttributeName: self.font])
            var scaleFactor: CGFloat = self.frame.size.width / unadjustedSize.width
            if scaleFactor >= 1.0 {
                // the text already fits at full font size
                return self.font.pointSize
            }
            // Respect minimumScaleFactor
            scaleFactor = max(scaleFactor, minimumScaleFactor)
            let newFontSize: CGFloat = self.font.pointSize * scaleFactor
            // Uncomment this if you insist on integer font sizes
            //newFontSize = floor(newFontSize);
            return newFontSize
        }
    }
}

class KScoreLabel: UIView {

    var animationDuration:Double = 0.2
    var scoreBoardAnimationKeyRemoveWhenDone = "removeWhenDone"
//    let fakeLabel = UILabel()
    let correctLabel = UILabel()
    let colonLabel = UILabel()
    let mistakesLabel = UILabel()
    var correctCount:Int = 0
    var mistakesCount:Int = 0
    
    var fontSize:CGFloat = 36
    func initializeLabel(fontSize:CGFloat) {
        self.fontSize = fontSize

        self.addSubview(correctLabel)
        self.addSubview(colonLabel)
        self.addSubview(mistakesLabel)

        correctLabel.translatesAutoresizingMaskIntoConstraints = false
        colonLabel.translatesAutoresizingMaskIntoConstraints = false
        mistakesLabel.translatesAutoresizingMaskIntoConstraints = false

        
        let sviews = [
            "correctLabel" : correctLabel,
            "colonLabel" : colonLabel,
            "mistakesLabel" : mistakesLabel
        ]
        
        let shConstraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[correctLabel][colonLabel][mistakesLabel]|", options: [.AlignAllTop, .AlignAllBottom, NSLayoutFormatOptions.AlignAllCenterY], metrics: nil, views: sviews)
        let svConstraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[correctLabel]|", options: [], metrics: nil, views: sviews)
        
        self.addConstraints([shConstraints0, svConstraints0].flatMap{$0})
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        self.backgroundColor = UIColor.clearColor()
        
        
        self.correctLabel.numberOfLines = 1
        self.correctLabel.textAlignment = NSTextAlignment.Left
        self.correctLabel.textColor = ColorFromCode.colorWithHexString("#D0F1F8")
        self.correctLabel.text = "0"
        self.correctLabel.font = UIFont(name: "Helvetica-Bold", size: fontSize)
//        self.correctLabel.adjustsFontSizeToFitWidth = true

        self.colonLabel.numberOfLines = 1
        self.colonLabel.textAlignment = NSTextAlignment.Left
        self.colonLabel.text = " : "
        self.colonLabel.textColor = UIColor.whiteColor()
        self.colonLabel.font = UIFont(name: "Helvetica-Bold", size: fontSize)
//        self.colonLabel.adjustsFontSizeToFitWidth = true

        self.mistakesLabel.numberOfLines = 1
        self.mistakesLabel.textAlignment = NSTextAlignment.Left
        self.mistakesLabel.textColor = ColorFromCode.colorWithHexString("#FFDCCB")
        self.mistakesLabel.font = UIFont(name: "Helvetica-Bold", size: fontSize)
        self.mistakesLabel.text = "0"
//        self.mistakesLabel.adjustsFontSizeToFitWidth = true

        
        ///        let vConstraint3 = NSLayoutConstraint(item: colonLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: correctLabel, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    }
    
    var factor:CGFloat = 1
    
    
    func updateFactor() {
        let numberOfDigitsInCorrect = CGFloat("\(correctCount)".characters.count)
        let numberOfDigitsInMistakes = CGFloat("\(mistakesCount)".characters.count)
        
        let differenceInSize:CGFloat = 0.075
        let decrementFromCorrect = (numberOfDigitsInCorrect-1)*differenceInSize
        let decrementFromMistakes = (numberOfDigitsInMistakes-1)*differenceInSize
        factor = 1 - decrementFromCorrect - decrementFromMistakes
//        print(" Text decrement factor : \(factor)")
    }
    func updateCorrectLabel(correctCnt:Int) {
        
        
        correctCount = correctCnt
//        self.fakeLabel.text = "\(correctCnt) : \(mistakesCount)"
        self.correctLabel.text = "\(correctCnt)"
        
        updateFactor()
        
        mistakesLabel.font = mistakesLabel.font.fontWithSize(fontSize*factor)
        correctLabel.font = correctLabel.font.fontWithSize( fontSize*factor)
        colonLabel.font = colonLabel.font.fontWithSize( fontSize*factor)
        
        let animationDuration = 0.1
        self.correctLabel.text = "\(correctCnt)"
        UIView.animateWithDuration(animationDuration, animations: {() -> Void in
            
            self.correctLabel.transform = CGAffineTransformMakeScale(1.15, 1.15)
            
            }, completion: {(finished: Bool) -> Void in
                UIView.animateWithDuration(animationDuration, animations: {() -> Void in
                    
                    self.correctLabel.transform = CGAffineTransformMakeScale(1, 1)
                    }, completion: {(finished: Bool) -> Void in
                        // clean up 
                })
        })

        
//
//
//        
//        if correctLabel.fontSize != mistakesLabel.fontSize {
//            mistakesLabel.font = mistakesLabel.font.fontWithSize( mistakesLabel.fontSize*1.2)
//            correctLabel.font = correctLabel.font.fontWithSize( mistakesLabel.fontSize*1.2)
//            colonLabel.font = colonLabel.font.fontWithSize( mistakesLabel.fontSize*1.2)
//        }
        
    }
    
    func updateMistakesLabel(mistakesCnt:Int) {
        
        mistakesCount = mistakesCnt
//        self.fakeLabel.text = "\(correctCount) : \(mistakesCnt)"

        
        
        updateFactor()
        
        
        mistakesLabel.font = mistakesLabel.font.fontWithSize(fontSize*factor)
        correctLabel.font = correctLabel.font.fontWithSize(fontSize*factor)
        colonLabel.font = colonLabel.font.fontWithSize(fontSize*factor)

        let animationDuration = 0.1
        self.mistakesLabel.text = "\(mistakesCnt)"
        UIView.animateWithDuration(animationDuration, animations: {() -> Void in
            
            self.mistakesLabel.transform = CGAffineTransformMakeScale(1.32, 1.32)
            
            }, completion: {(finished: Bool) -> Void in
                UIView.animateWithDuration(animationDuration, animations: {() -> Void in
                    
                    self.mistakesLabel.transform = CGAffineTransformMakeScale(1, 1)
                    }, completion: {(finished: Bool) -> Void in
                        // clean up
                })
        })
        

    }
    
    init() {
        super.init(frame: CGRectZero)
//        self.initializeLabel(36)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
