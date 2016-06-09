//
//  MenuButton.swift
//  KeySpeed
//
//  Created by Grisha on 19/05/2016.
//  Copyright © 2016 Grisha. All rights reserved.
//

import UIKit

class ShrinkButton: UIButton {

    var shrinked = false
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        shrinked = true
        highlight()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        
        if touchInside {
            if !shrinked {
                highlight()
            }
        } else {
            if shrinked {
                unhighlight()
            }
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        shrinked = false
        unhighlight()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        shrinked = false
        unhighlight()
        
    }
    
    func highlight() {
        UIView.animateWithDuration(0.25, animations:{
            self.transform = CGAffineTransformMakeScale(0.75, 0.75)
            self.backgroundColor = UIColor.grayColor()
            self.alpha = 0.75
        })
    }
    
    func unhighlight() {
        UIView.animateWithDuration(0.25, animations:{
            self.transform = CGAffineTransformMakeScale(1,1)
            self.backgroundColor = UIColor.blackColor()
            self.alpha = 1
        })
    }


}
