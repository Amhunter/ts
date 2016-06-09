//
//  ShrinkButton.swift
//  KeySpeed
//
//  Created by Grisha on 19/05/2016.
//  Copyright © 2016 Grisha. All rights reserved.
//

import UIKit

class ExpandButton: UIButton {
    var largened = false
    
    init() {
        super.init(frame: CGRectZero)
        self.adjustsImageWhenHighlighted = false

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        largened = true
        highlight()
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        
        if touchInside {
            if !largened {
                highlight()
            }
        } else {
            if largened {
                unhighlight()
            }
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        largened = false
        unhighlight()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        largened = false
        unhighlight()

    }
    
    func highlight() {
        UIView.animateWithDuration(0.25, animations:{
            self.transform = CGAffineTransformMakeScale(1.25, 1.25)
            self.alpha = 0.75
        })
    }
    
    func unhighlight() {
        UIView.animateWithDuration(0.25, animations:{
            self.transform = CGAffineTransformMakeScale(1,1)
            self.alpha = 1
        })
    }
}
